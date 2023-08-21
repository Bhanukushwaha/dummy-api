class ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :descreption
  attribute :is_like do |object|
    Like.where(user_id: current_user.id, likeable_id: object.object.id, likeable_type: "Article").present?
  end
end
