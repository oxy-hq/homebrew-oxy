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
  response = Net::HTTP.get(url)
  JSON.parse(response)
end

def read_sha_sums(file_path)
  sha_sums = {}
  File.readlines(file_path).each do |line|
    sha, name = line.strip.split(' *')
    sha_sums[name] = sha
  end
  sha_sums
end

def download_sha_sums_file(url, destination)
  File.open(destination, 'wb') do |file|
    file.write(Net::HTTP.get(URI(url)))
  end
end

def update_formula(version, sha256_darwin_intel, sha256_darwin_arm, sha256_linux_intel, sha256_linux_arm)
  formula_path = File.join(__dir__, '../Formula/oxy.rb')
  content = File.read(formula_path)

  current_version = content.match(/@@version = "(\d+\.\d+\.\d+)"/)[1]

  if Gem::Version.new(version) > Gem::Version.new(current_version)
    content.gsub!(/@@version = "\d+\.\d+\.\d+"/, "@@version = \"#{version}\"")
    content.gsub!(/sha256 "[a-f0-9]{64}"/, "sha256 \"#{sha256_darwin_intel}\"", 1)
    content.gsub!(/sha256 "[a-f0-9]{64}"/, "sha256 \"#{sha256_darwin_arm}\"", 1)
    content.gsub!(/sha256 "[a-f0-9]{64}"/, "sha256 \"#{sha256_linux_intel}\"", 1)
    content.gsub!(/sha256 "TBD"/, "sha256 \"#{sha256_linux_arm}\"")

    File.write(formula_path, content)
  end
end

def fetch_asset_url(release, asset_name)
  asset = release['assets'].find { |a| a['name'] == asset_name }
  asset ? asset['browser_download_url'] : nil
end

def download_and_read_sha_sums(release, file_name)
  sha_sums_file_path = File.join(__dir__, file_name)
  url = fetch_asset_url(release, file_name)
  raise "Asset #{file_name} not found in release" unless url

  download_sha_sums_file(url, sha_sums_file_path)
  read_sha_sums(sha_sums_file_path)
end

def fetch_sha_values(sha_sums, keys)
  keys.map { |key| sha_sums.fetch(key, 'TBD') }
end

def update_formula_with_release(release, sha_keys)
  version = release['tag_name']
  sha_sums = download_and_read_sha_sums(release, 'SHA256SUMS.txt')
  sha_values = fetch_sha_values(sha_sums, sha_keys)

  update_formula(version, *sha_values)
end

release = fetch_latest_release
sha_keys = [
  'oxy-x86_64-apple-darwin',
  'oxy-aarch64-apple-darwin',
  'oxy-x86_64-unknown-linux-gnu',
  'oxy-aarch64-unknown-linux-gnu'
]

update_formula_with_release(release, sha_keys)
