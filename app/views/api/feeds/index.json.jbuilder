json.topics @topics do |topic|
  json.name topic.name
end

json.questions @questions do |question|
  json.id question.id
  json.title question.title
  json.content question.content
  json.created_at question.created_at

  json.topics question.topics do |topic|
    json.name topic.name
  end

  json.answers question.answers do |answer|
    json.id answer.id
    json.content answer.content
    json.created_at answer.created_at
  end

  json.comments question.comments do |comment|
    json.id comment.id
    json.content comment.content
    json.created_at comment.created_at
  end
end
