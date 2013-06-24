ActiveAdmin.register Email do
  form do |f|
    f.inputs "Email Details" do
      f.input :episode
      f.input :subject
      f.input :body, as: :html_editor
      f.input :sender
      f.input :recipient, as: :string, hint: "Read-only", input_html: { readonly: true, disabled: true, value: ENV["DEFAULT_MAILING_LIST"]}

      f.input :header_note,
        as: :html_editor,
        label: "Additional email note",
        hint: "Appears at the top of the email"

      f.input :proofed_at,
        as: :string,
        hint: "Read-only",
        input_html: { readonly: true, disabled: true }

      f.input :proofed_by,
        as: :string,
        hint: "Read-only",
        input_html: { readonly: true, disabled: true, value: f.object.proofed_by.try(:name) }

      f.input :sent_at,
        as: :string,
        hint: "Read-only",
        input_html: { readonly: true, disabled: true }
    end

    f.actions
  end
end
