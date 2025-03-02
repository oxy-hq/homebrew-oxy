=begin
Example SHA sums file content:
e847fa8d1cb0435afcc17cf3ac32e88908258b20a059a67b67388fcde2914f0d *onyx-aarch64-apple-darwin
93b08c93797ed00b3407323a398fa3d077d3ba3c2df23e7df1ba9def6535aff8 *onyx-x86_64-apple-darwin
ddb17359dcaec0f8164f2a872906d97281153f06ca8cf6246a24a8a06023cea7 *onyx-x86_64-unknown-linux-gnu

Example release assets:
onyx-aarch64-apple-darwin
onyx-x86_64-apple-darwin
onyx-x86_64-unknown-linux-gnu
onyx_py-0.1.1-cp311-cp311-macosx_11_0_arm64.whl
onyx_py-0.1.1-cp311-cp311-macosx_11_0_x86_64.whl
onyx_py-0.1.1-cp311-cp311-manylinux_2_39_x86_64.whl
SHA256SUM-onyx-aarch64-apple-darwin.txt
SHA256SUM-onyx-x86_64-apple-darwin.txt
SHA256SUM-onyx-x86_64-unknown-linux-gnu.txt
SHA256SUMS.txt
=end

require 'net/http'
require 'json'

def fetch_latest_release
  url = URI("https://api.github.com/repos/onyx-hq/onyx/releases/latest")
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

def update_formula(version, sha256_darwin_intel, sha256_darwin_arm, sha256_linux_intel, sha256_linux_arm)
  formula_path = File.join(__dir__, '../Formula/onyx.rb')
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

release = fetch_latest_release
version = release['tag_name']
sha_sums = read_sha_sums(File.join(__dir__, 'SHA_sums'))

sha256_darwin_intel = sha_sums['onyx-x86_64-apple-darwin']
sha256_darwin_arm = sha_sums['onyx-aarch64-apple-darwin']
sha256_linux_intel = sha_sums['onyx-x86_64-unknown-linux-gnu']
sha256_linux_arm = sha_sums['onyx-aarch64-unknown-linux-gnu']

update_formula(version, sha256_darwin_intel, sha256_darwin_arm, sha256_linux_intel, sha256_linux_arm)
