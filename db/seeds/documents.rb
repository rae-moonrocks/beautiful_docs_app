# This is currently a manual process. Take a copy of the readme.md file and paste it into the db/files folder + the timestamp: Time.now.utc.strftime('%Y%m%d%H%M%S')

file_path = './db/files/beautiful_docs_readme_20241113230742.md'
file_content = File.read(file_path)
html        =  Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(file_content)
parsed_data = Nokogiri::HTML.parse(html)
line_items = parsed_data.css('li')

# Assumes if there are multiple links in a list item, the last link is the contributor type
def format_contributor_type(a_elements)
  contributor_type = a_elements.last
  if contributor_type['href']&.include?('twitter.com')
    'Twitter'
  elsif contributor_type['href']&.include?('github.com')
    'GitHub'
  end
end

formatted_items = line_items.map do |li|
  {
    title: li.at_css('a')&.text,
    url: li.at_css('a')&.[]('href'),
    description: li.children.reject { |child| child.name == 'a' }.map(&:text).join.strip.sub(/^-\s*/, '').sub(/\s\(contributed by \)$/, ''),
    contributor: li.css('a').map { |a| a.text if a['href']&.include?('twitter.com') || a['href']&.include?('github.com') }.compact.join(', '),
    contributor_type: format_contributor_type(li.css('a')),
    unparsed_html: li.to_html
  }
end.compact

formatted_items.each do |data|
  document = Document.find_or_initialize_by(url: data[:url])
  document.update!(data)

  puts "Document: #{document.title} created"
end
