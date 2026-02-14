module ApplicationHelper
    def markdown(text)
      renderer = Redcarpet::Render::HTML.new(
        hard_wrap: true,
        link_attributes: { rel: "nofollow", target: "_blank" }
      )

      options = {
        autolink: true,
        tables: true,
        fenced_code_blocks: true,
        strikethrough: true,
        lax_spacing: true,
        space_after_headers: true
      }

      Redcarpet::Markdown.new(renderer, options).render(text).html_safe
    end
end
