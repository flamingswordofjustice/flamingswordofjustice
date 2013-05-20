ActiveAdmin.register_page "Listeners" do

  content :title => proc{ I18n.t("active_admin.listeners") } do
    table class: "listeners index_table index", "data-tracking-uri" => listener_tracking_uri do
      thead do
        tr do
          th "Start Time"
          th "Total Listen Time"
          th "Episode ID"
          th "Referrer"
          th "Play state"
          th "Episode State"
        end
      end

      tbody "data-bind" => "foreach: listeners" do
        tr "data-bind" => "click: $parent.selectListener" do
          td "", "data-bind" => "text: startTime"
          td "", "data-bind" => "text: listenTimeFormatted"
          td "", "data-bind" => "text: episodeId"
          td "", "data-bind" => "text: ref"
          td "", "data-bind" => "text: state"
          td "", "data-bind" => "text: episodeState"
        end
      end
    end
  end

  sidebar "Filter" do
    select do
      option "All Episodes", value: ""
      Episode.all.each do |e|
        option e.title, value: e.slug
      end
    end
  end

  sidebar "More Details", class: "foo" do
    table "data-bind" => "with: activeListener" do
      tr { th "Session ID" }
      tr { td "", "data-bind" => "text: sessionId" }

      tr { th "Plays" }
      tr do
        td do
          dl "data-bind" => "foreach: listens" do
            dt "", "data-bind" => "text: type"
            dd "", "data-bind" => "text: timestamp"
          end
        end
      end
    end
  end

end
