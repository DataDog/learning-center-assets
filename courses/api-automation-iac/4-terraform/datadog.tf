resource "datadog_monitor" "redis_cpu" {
  name = "Stately! Average Redis System CPU Usage"
  type = "metric alert"
  message = "Uh oh. Redis is burning up the CPU! @sre@example.com"
  
  query = "avg(last_5m):max:redis.cpu.sys{env:api-course,service:redis-session-cache} by {service,env} >= .2"

  monitor_thresholds {
    warning           = ".1"
    warning_recovery  = ".05"
    critical          = ".2"
    critical_recovery = ".1"
  }
  tags = ["env:api-course", "service:redis-session-cache"]
}

resource "datadog_dashboard" "redis_session_cache_dash" {
  title         = "Stately! Dashboard"
  description   = "Created using the Datadog provider in Terraform"
  layout_type   = "free"
  is_read_only  = true

  widget {
    alert_graph_definition {
      alert_id = "${datadog_monitor.redis_cpu.id}"
      viz_type = "timeseries"
      title = "Redis System CPU Usage"
      title_size = 16
      live_span = "30m"
    }
    widget_layout {
      x = 1
      y = 0
      width = 32
      height = 37
    }
  }

  widget {
    check_status_definition {
      check = "datadog.agent.check_status"
      grouping = "check"
      group = "check:redisdb,host:api-course-host"
      title = "Redis Up"
      title_size = 16
      live_span = "30m"
    }
    widget_layout {
      height = 18
      width  = 32
      x      = 34
      y      = 0
    }
  }
  widget {
    note_definition {
      content          = "This dashboard was created by Terraform in **API Course** lab!"
      background_color = "purple"
      font_size        = "36"
      text_align       = "center"
      vertical_align   = "center"
      show_tick        = false
      tick_edge        = "left"
      tick_pos         = "50%"
      has_padding      = true
    }
    widget_layout {
      height = 18
      width  = 32
      x      = 34
      y      = 19
    }
  }
  widget {
    log_stream_definition {
      title               = "Stately Error Logs"
      title_size          = "16"
      indexes             = []
      query               = "status:error"
      columns             = ["core_host", "core_service", "tag_source"]
      show_date_column    = true
      show_message_column = true
      message_display     = "expanded-md"
      live_span           = "30m"
      sort {
        column = "time"
        order  = "desc"
      }
    }
    widget_layout {
      height = 37
      width  = 72
      x      = 67
      y      = 0
    }
  }
  widget {
    trace_service_definition {
      display_format     = "three_column"
      env                = "api-course"
      service            = "stately-app"
      show_breakdown     = true
      show_distribution  = true
      show_errors        = true
      show_hits          = true
      show_latency       = true
      show_resource_list = false
      size_format        = "large"
      title              = "Falcon Requests"
      title_align        = "center"
      title_size         = "16"
      span_name          = "falcon.request"
      live_span          = "30m"
    }
    widget_layout {
      height = 50
      width  = 103
      x      = 1
      y      = 38
    }
  }

  widget {
    timeseries_definition {
      title = "System CPU by image"
      title_size = "16"
      title_align = "left"
      show_legend = false
      legend_layout = "auto"
      legend_columns = [
          "avg",
          "min",
          "max",
          "value",
          "sum"
      ]
      live_span = "30m"
      request {
        q = "avg:docker.cpu.system{env:api-course} by {docker_image}.fill(0)"
        style  {
          palette = "cool"
        }
        display_type = "line"
      }
      yaxis {
          scale = "linear"
          label = ""
          include_zero = true
          min = "auto"
          max = "auto"
      }
    }
    widget_layout {
      height = 50
      width  = 34
      x      = 105
      y      = 38
    }
  }

}
