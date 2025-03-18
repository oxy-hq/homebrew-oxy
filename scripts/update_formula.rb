=begin
Example SHA sums file content:
e847fa8d1cb0435afcc17cf3ac32e88908258b20a059a67b67388fcde2914f0d *oxy-aarch64-apple-darwin
93b08c93797ed00b3407323a398fa3d077d3ba3c2df23e7df1ba9def6535aff8 *oxy-x86_64-apple-darwin
ddb17359dcaec0f8164f2a872906d97281153f06ca8cf6246a24a8a06023cea7 *oxy-x86_64-unknown-linux-gnu

Example release assets:
oxy-aarch64-apple-darwin
oxy-x86_64-apple-darwin
oxy-x86_64-unknown-linux-gnu
oxy_py-0.1.1-cp311-cp311-macosx_11_0_arm64.whl
oxy_py-0.1.1-cp311-cp311-macosx_11_0_x86_64.whl
oxy_py-0.1.1-cp311-cp311-manylinux_2_39_x86_64.whl
SHA256SUM-oxy-aarch64-apple-darwin.txt
SHA256SUM-oxy-x86_64-apple-darwin.txt
SHA256SUM-oxy-x86_64-unknown-linux-gnu.txt
SHA256SUMS.txt
=end

require 'net/http'
require 'json'

def fetch_latest_release
  url = URI("https://api.github.com/repos/oxy-hq/oxy/releases/latest")
  request = Net::HTTP::Get.new(url)
  github_token = ENV['GITHUB_TOKEN']
  request['Authorization'] = "token #{github_token}" if github_token

  response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) { |http| http.request(request) }
  raise "Failed to fetch release: #{response.code} #{response.message}" unless response.is_a?(Net::HTTPSuccess)

  JSON.parse(response.body)
end

def download_file(url, destination)
  uri = URI(url)
  response = Net::HTTP.get_response(uri)
  response = Net::HTTP.get_response(URI(response['location'])) if response.is_a?(Net::HTTPRedirection)
  raise "Failed to download file: #{response.code} #{response.message}" unless response.is_a?(Net::HTTPSuccess)

  File.write(destination, response.body)
end

def read_sha_sums(file_path)
  File.readlines(file_path).each_with_object({}) do |line, sha_sums|
    sha, name = line.strip.split(' *')
    sha_sums[name] = sha
  end
end

def update_formula(version, sha256_values)
  formula_path = File.join(__dir__, '../Formula/oxy.rb')
  content = File.read(formula_path)

  content.gsub!(/@@version = "\d+\.\d+\.\d+"/, "@@version = \"#{version}\"")
  sha256_values.each do |key, value|
    content.gsub!(/#{key}: "[a-f0-9]{64}"/, "#{key}: \"#{value}\"")
  end

  File.write(formula_path, content)
end

def process_release(release)
  version = release['tag_name']
  sha_sums_url = release['assets'].find { |asset| asset['name'] == 'SHA256SUMS.txt' }['browser_download_url']
  sha_sums_file = File.join(__dir__, 'SHA256SUMS.txt')

  download_file(sha_sums_url, sha_sums_file)
  sha_sums = read_sha_sums(sha_sums_file)

  sha256_values = {
    darwin_intel: sha_sums.fetch('oxy-x86_64-apple-darwin', 'TBD'),
    darwin_arm: sha_sums.fetch('oxy-aarch64-apple-darwin', 'TBD'),
    linux_intel: sha_sums.fetch('oxy-x86_64-unknown-linux-gnu', 'TBD'),
    linux_arm: sha_sums.fetch('oxy-aarch64-unknown-linux-gnu', 'TBD')
  }

  update_formula(version, sha256_values)
end

release = fetch_latest_release
process_release(release)
