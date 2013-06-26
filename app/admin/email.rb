ActiveAdmin.register Email do
  member_action :proof, method: :post do
    email = Email.find(params[:id])
    email.proof!
    redirect_to admin_email_path(email), notice: "Email successfully sent to #{email.proof_recipient}."
  end

  member_action :deliver, method: :post do
    email = Email.find(params[:id])
    email.send!(current_user)
    redirect_to admin_email_path(email), notice: "Email successfully sent to #{email.recipient}."
  end

  member_action :confirm, method: :get do
    @email = Email.find(params[:id])
  end

  controller do
    def new
      @email = Email.new(
        sender: t(:email_sender),
        recipient: ENV["DEFAULT_MAILING_LIST"]
      )
      new!
    end
  end

  show do
    render partial: 'admin/shared/iframe', locals: { src: email_url(email) }
  end

  action_item(only: :edit) { link_to "View Email", admin_email_path(email.id) }
  action_item(only: [:edit, :show]) { link_to "Confirm Email", confirm_admin_email_path(email.id) }

  action_item only: [:edit, :show] do
    form_tag proof_admin_email_path(resource.id), style: "display: inline-block" do
      submit_tag("Send proof to #{resource.proof_recipient}")
    end
  end

  index do
    column :subject
    column :sender
    column :recipient
    column :episode
    column :proofed_at
    column :proofed_by
    column :sent_at
    default_actions
  end


  form do |f|
    f.inputs "Email Details" do
      f.input :episode
      f.input :sender
      f.input :recipient
      f.input :subject
      f.input :body, as: :html_editor

      f.input :header_note,
        as: :html_editor,
        label: "Additional email note",
        hint: "Appears at the top of the email"

      f.input :proofed_at, as: :readonly
      f.input :proofed_by_id, as: :readonly, text: f.object.proofed_by.try(:name)
      f.input :sent_at, as: :readonly
    end

    f.actions do
      f.action :submit
      f.action :cancel, wrapper_html: { class: "cancel" }
    end
  end
end
