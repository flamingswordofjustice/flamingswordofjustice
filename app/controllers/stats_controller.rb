class StatsController < ApplicationController

  def index
    target = params[:target]
    from   = params[:from] || "-24h"

    # raise target.inspect
    render json: RestClient.get("http://#{ENV['STATSD_HOST']}/render",
      params: { target: target, from: from, format: "json" }
    )
  end

end
