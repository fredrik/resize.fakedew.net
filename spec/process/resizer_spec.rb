
require_relative '../../process/resizer'

afghan_girl_path = File.expand_path(
  'fixtures/afghan-girl.jpg', File.dirname(__FILE__)
)

describe Resizer do
  let(:subject) { Resizer }
  let(:image_blob) { File.read(afghan_girl_path) }

  it 'responds to #resize' do
    expect(subject).to respond_to(:resize)
  end

  it 'raises on empty input' do
    expect { Resizer.resize(nil) }.to raise_error(TypeError)
  end

  it 'resizes an image to 400x300 pixels' do
    image = Resizer.resize(image_blob)

    expect(image.format).to eq("JPEG")
    expect(image.columns).to eq(400)
    expect(image.rows).to eq(300)
  end
end
