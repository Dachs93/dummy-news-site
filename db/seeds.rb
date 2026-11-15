# Idempotent seeds: safe to run repeatedly (bin/rails db:seed).

categories = [
  [ "Languages", "Language releases, type systems, compilers and runtimes." ],
  [ "Web", "Frameworks, browsers, frontend architecture and the platform." ],
  [ "DevOps", "Deployment, infrastructure, CI/CD and observability." ],
  [ "AI & ML", "AI-assisted development, LLM tooling and machine learning in practice." ],
  [ "Databases", "SQL, NoSQL, storage engines and data modeling." ],
  [ "Security", "Vulnerabilities, supply-chain safety and secure-by-default engineering." ],
  [ "Tools", "Editors, CLIs, version control and developer productivity." ],
  [ "Open Source", "Projects, maintainers, licensing and community." ]
]
categories.each_with_index do |(name, description), position|
  Category.find_or_initialize_by(name: name).update!(description: description, position: position)
end

authors = [
  [ "Maya Okafor", "Senior Editor", "Covers infrastructure, deployment and the business of developer tools. Previously a platform engineer." ],
  [ "Daniel Reyes", "Staff Writer", "Writes about web frameworks, databases and keeping things simple." ],
  [ "Priya Natarajan", "Staff Writer", "Covers programming languages, compilers and type systems." ],
  [ "Samuel Brandt", "Security Correspondent", "Reports on application security, supply-chain risk and observability." ],
  [ "Editorial Team", "Editors", "The software-devs editorial desk." ]
]
authors.each do |name, role, bio|
  Author.find_or_initialize_by(name: name).update!(role: role, bio: bio)
end

# Articles are plain Markdown files with front matter — the same format the
# admin "New article" page accepts. See docs/article_template.md.
#
# Images live next to the .md files and are referenced by bare filename, both
# as the cover (`image: 01-foo-cover.png`) and inline (`![alt](01-foo-diagram.png)`).
# Each one is uploaded to Admin → Images (once; re-seeding reuses it) and the
# filename is replaced with the uploaded image's URL.
seed_dir = Rails.root.join("db/seeds/articles")
image_ext = /\.(?:png|jpe?g|gif|webp|avif)\z/i

seed_image_url = ->(filename) do
  path = seed_dir.join(filename)
  raise "Seed image not found: #{path}" unless path.file?

  checksum = ActiveStorage::Blob.build_after_unfurling(io: File.open(path), filename: filename).checksum
  upload = Upload.joins(file_attachment: :blob).find_by(active_storage_blobs: { filename: filename, checksum: checksum })
  upload ||= Upload.create!(title: File.basename(filename, ".*").tr("-", " ").capitalize,
                            file: { io: File.open(path), filename: filename })
  Rails.application.routes.url_helpers.rails_blob_path(upload.file, only_path: true)
end

local_image = ->(ref) { ref.match?(image_ext) && !ref.start_with?("/") && !ref.include?("://") }

Dir[seed_dir.join("*.md")].sort.each do |path|
  text = File.read(path)
  text = text.sub(/^(image:[ \t]*)(\S+)[ \t]*$/) { local_image.($2) ? "#{$1}#{seed_image_url.($2)}" : $& }
  text = text.gsub(/(!\[[^\]]*\]\()([^)\s]+)/) { local_image.($2) ? "#{$1}#{seed_image_url.($2)}" : $& }

  markdown = ArticleMarkdown.new(text)
  title = markdown.front_matter["title"]
  article = Article.find_by(title: title) || Article.new

  if markdown.assign_to(article) && article.save
    puts "  seeded #{File.basename(path)}"
  else
    warn "  skipped #{File.basename(path)}: #{article.errors.full_messages.to_sentence}"
  end
end

# Admin user. In production, set ADMIN_EMAIL and ADMIN_PASSWORD when seeding.
admin_email = ENV.fetch("ADMIN_EMAIL") { "admin@software-devs.com" if Rails.env.local? }
admin_password = ENV.fetch("ADMIN_PASSWORD") { "password" if Rails.env.local? }
if admin_email && admin_password
  User.find_or_initialize_by(email_address: admin_email).update!(password: admin_password)
  puts "  admin user: #{admin_email}"
else
  puts "  no admin user created — set ADMIN_EMAIL and ADMIN_PASSWORD"
end
