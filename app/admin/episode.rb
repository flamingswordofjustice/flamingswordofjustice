ActiveAdmin.register Episode do
  config.sort_order = "published_at_desc"

  breadcrumb do
    if params[:id].present?
      [
        link_to("Admin", admin_root_path),
        link_to("Episodes", admin_episodes_path),
        link_to(resource.display_name, admin_episode_path(resource))
      ]
    end
  end

  member_action :send_email, method: :post do
    email = EpisodeEmail.new(
      id:         params[:id],
      recipient:  params[:recipient],
      proofed:    params[:proofed].present?,
      sender:     params[:sender] || I18n.t(:email_sender),
      admin_user: current_user,
      renderer:   self
    )

    if email.recipient.blank?
      redirect_to admin_episode_path(@episode), error: "No recipient given for email."
    else
      email.send!
      redirect_to admin_episode_path(@episode), notice: "Email successfully sent to #{email.recipient}."
    end
  end

  member_action :mixpanel_stats, method: :get do
    client = Mixpanel::Client.new(
      api_key: ENV['MIXPANEL_API_KEY'],
      api_secret: ENV['MIXPANEL_API_SECRET'],
      parallel: true
    )

    all_funnels_req = client.request "funnels/list", {}
    client.run_parallel_requests
    funnels = all_funnels_req.response.handled_response

    episode = Episode.where(slug: params[:id]).first
    base_props = {
      where: %{properties["Episode"]=="#{episode.slug}"},
      on:    %{properties["Ref code"]},
      from_date: 29.days.ago.to_date.to_s(:db),
      to_date: Date.today.to_s(:db),
      interval: 30
    }

    funnel_id = lambda {|name| funnels.find {|f| f["name"] == name}.try(:[], "funnel_id")}

    likes      = client.request "funnels", base_props.merge(funnel_id: funnel_id.call("Viewed Played Liked"))
    subscribes = client.request "funnels", base_props.merge(funnel_id: funnel_id.call("Viewed Played Subscribed"))

    client.run_parallel_requests

    overall_data = lambda {|req| req.response.handled_response["data"].values.first["$overall"]}

    resp = {
      "Liked" => overall_data.call(likes),
      "Subscribed" => overall_data.call(subscribes)
    }

    render json: resp
  end

  member_action :confirm_email, method: :get do
    @episode = Episode.find(params[:id])
  end

  show { render "show" }

  index do
    column "Name", :title
    column :headline
    column :published_at
    column :state
    column(:guests) { |e| e.guests.map {|g| link_to g.name, edit_admin_person_path(g.slug) }.join(', ').html_safe }
    column(:topics) { |e| e.topics.map {|t| link_to t.name, edit_admin_topic_path(t.slug) }.join(', ').html_safe }
    default_actions
  end

  filter :published_at

  action_item only: [:edit, :show] do
    name = resource.class.model_name
    link_to "View Live #{active_admin_config.resource_label}", polymorphic_url(resource, protocol: "http"), target: "_new"
  end

  action_item only: [:edit, :show] do
    form_tag send_email_admin_episode_path(resource.slug), style: "display: inline-block" do
      hidden_field_tag('sender', ENV['EMAIL_TEST_RECIPIENT']) +
      hidden_field_tag('recipient', ENV['EMAIL_TEST_RECIPIENT']) +
      submit_tag("Send Test Email")
    end
  end

  form html: { multipart: true } do |f|
    f.object.host = Episode.default_host if f.object.new_record?

    f.inputs "Episode Details" do
      f.input :title, label: "Name"
      f.input :download_url
      f.input :host
      f.input :description, as: :html_editor
      f.input :show_notes, as: :html_editor
      f.input :state, as: :select,
        collection: f.object.possible_states,
        selected: f.object.state || f.object.default_state
      f.input :published_at, as: :date_select
      f.input :image, as: :image_upload#, preview: :thumb
      f.input :image_caption

      f.input :filepicker_images, as: :file_picker, multiple: true

      # filepicker_image_tag f.object.image, watermark: "http://www.flamingswordofjustice.com/assets/play-button.png", waterposition: "middle,middle", watersize: "20%"
      # http://www.flamingswordofjustice.com/assets/play-button.png
    end

    f.inputs "Social and Sharing" do
      redirects = Redirect.pointed_at(f.object).order(:path)
      f.input :redirect, label: "Canonical short link",
        collection: redirects,
        selected: f.object.redirect_id || redirects.first.try(:id),
        hint: link_to("Add new redirect", new_admin_redirect_path, target: "_new")

      f.input :headline, label: "Catchy headline"

      f.input :social_description, label: "Pithy Facebook description",
        hint: content_tag(:span, "", class: "charlimit"),
        input_html: { rows: 3, maxlength: 100 }

      f.input :twitter_text, label: "Viral Twitter text",
        as: :text,
        hint: content_tag(:span, "", class: "charlimit") + t("admin.twitter_text").html_safe,
        input_html: { rows: 3, maxlength: 102 }

      f.input :share_progress_code, label: "ShareProgress code",
        hint: "If running a ShareProgress experiment, use the code they give you here."
    end

    f.inputs "Email" do
      f.input :email_note,
        as: :html_editor,
        label: "Additional email note",
        hint: "Appears at the top of the email"

      f.input :email_proofed_at,
        as: :string,
        hint: "Read-only",
        input_html: { readonly: true, disabled: true }

      f.input :email_proofed_by,
        as: :string,
        hint: "Read-only",
        input_html: { readonly: true, disabled: true, value: f.object.email_proofed_by.try(:name) }
    end

    f.inputs "Topics and Guests" do
      f.input :topics, hint: link_to("Add new topic", new_admin_topic_path, target: "_new")
      f.input :guests_attributes,
        input_html: { multiple: true },
        collection: f.object.possible_guests,
        selected: f.object.guests_attributes.map(&:last),
        hint: link_to("Add new guest", new_admin_person_path, target: "_new")
    end

    f.actions
  end
end
