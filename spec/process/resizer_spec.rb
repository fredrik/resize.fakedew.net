require_relative '../../process/resizer'

describe Resizer do
  let(:subject) { Resizer }
  let(:image_blob) {
   File.read(File.expand_path('fixtures/afghan-girl.jpg', File.dirname(__FILE__)))
 }

  it 'responds to #resize' do
    expect(subject).to respond_to(:resize)
  end

  it 'raises on empty input' do
    expect { Resizer.resize(nil) }.to raise_error(TypeError)
  end

  it 'resizes an image to 400x300 pixels' do
    i = Resizer.resize(image_blob)

    expect(i.format).to eq("JPEG")
    expect(i.columns).to eq(400)
    expect(i.rows).to eq(300)
  end

  it 'adds a 10 pixel black border' do
    i = Resizer.resize(image_blob)

    # grab a row of ten pixels at the very left and right edges
    expect(i.dispatch(0,        HEIGHT/2, 10, 1, 'RGB', true)).to eq([0.0] * 30)
    expect(i.dispatch(WIDTH-10, HEIGHT/2, 10, 1, 'RGB', true)).to eq([0.0] * 30)
    # grab a column of ten pixels at the very top and bottom
    expect(i.dispatch(WIDTH/2,         0, 1, 10, 'RGB', true)).to eq([0.0] * 30)
    expect(i.dispatch(WIDTH/2, HEIGHT-10, 1, 10, 'RGB', true)).to eq([0.0] * 30)
  end
end
