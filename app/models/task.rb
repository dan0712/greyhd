class Task < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  belongs_to :workstream, counter_cache: true

  has_many :task_user_connections, dependent: :destroy
  has_many :attachments, as: :entity, dependent: :destroy,
                         class_name: 'UploadedFile::Attachment'

  validates :name, :owner, :workstream, presence: true

  acts_as_list scope: :workstream

  default_scope { order(position: :asc) }
end
