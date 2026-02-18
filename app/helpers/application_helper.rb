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

  def sidebar_link_classes(path)
    base = "px-4 py-2.5 rounded-lg transition font-medium"

    if current_page?(path)
      "#{base} bg-violet-100 text-violet-700"
    else
      "#{base} text-gray-700 hover:bg-gray-100"
    end
  end

  def nested_dom_id(votable, prefix = nil)
    parts = []
    case obj
    when Question
      parts << "question_#{obj.id}"
    when Answer
      parts << "question_#{obj.question.id}"
      parts << "answer_#{obj.id}"
    when Comment
      commentable = obj.commentable
      if commentable.is_a?(Question)
        parts << "question_#{commentable.id}"
      elsif commentable.is_a?(Answer)
        parts << "question_#{commentable.question.id}"
        parts << "answer_#{commentable.id}"
      end
      parts << "comment_#{obj.id}"
    end
    prefix ? "#{prefix}_#{parts.join('_')}" : parts.join("_")
  end
end
