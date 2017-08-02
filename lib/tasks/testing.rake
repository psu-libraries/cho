# frozen_string_literal: true

namespace :cho do
  desc 'Creates a collection with many empty works'
  task :collection_test, [:length] => [:environment] do |_t, args|
    length = args.fetch(:length, 10).to_i
    collection = Collection.new
    collection.title = ['Collection of Empty Works']
    collection.description = ['Contains all the empty works used in the test']
    collection.keyword = ['collection-test']
    collection.apply_depositor_metadata('chouser@example.com')
    collection.visibility = 'open'
    collection.save

    report_file = File.open('public/collection_test.csv', 'w')
    report_file.write("count,time\n")
    (1..length).each do |count|
      i = Image.new
      i.title = ["Collection Test Work #{count}"]
      i.description = ['Empty work used for testing collections with many works']
      i.keyword = ['collection-test']
      i.apply_depositor_metadata('chouser@example.com')
      i.visibility = 'open'
      benchmark(report_file, count) do
        i.member_of_collections = [collection]
        i.save
      end
    end
    report_file.close
  end

  desc 'Creates a collection with works'
  task :works_test, [:length] => [:environment] do |_t, args|
    length = args.fetch(:length, 10).to_i
    FileUtils.rm_f('tmp/small_random.bin')
    FileUtils.cp('spec/fixtures/small_random.bin', 'tmp')

    collection = Collection.new
    collection.title = ['Collection of Small Works']
    collection.description = ['Contains works each with a 1 MB file']
    collection.keyword = ['works-test']
    collection.apply_depositor_metadata('chouser@example.com')
    collection.visibility = 'open'
    collection.save

    user = User.find_by(email: 'chouser@example.com')

    report_file = File.open('public/works_test.csv', 'w')
    report_file.write("count,time\n")

    (1..length).each do |count|
      randomize_file
      benchmark(report_file, count) do
        image = create_image(count)
        permissions = image.permissions.map(&:to_hash)
        file_set = FileSet.new
        actor = Hyrax::Actors::FileSetActor.new(file_set, user)
        actor.create_metadata(visibility: 'open')
        file_set.title = ["Small File #{count}"]
        file_set.label = "Small File #{count}"
        file_set.save
        Hydra::Works::AddFileToFileSet.call(file_set, File.open('tmp/small_random.bin', 'r'), :original_file)
        actor.attach_to_work(image)
        actor.file_set.permissions_attributes = permissions
        image.member_of_collections = [collection]
        image.save
      end
    end
    report_file.close
  end

  def create_image(count)
    image = Image.new
    image.title = ["Small Work #{count}"]
    image.description = ['A small work containing one 1 MB file']
    image.keyword = ['works-test']
    image.visibility = 'open'
    image.apply_depositor_metadata('chouser@example.com')
    image.save
    image
  end

  def randomize_file
    File.open('tmp/small_random.bin', 'a') do |file|
      file.truncate((file.size - 36))
      file.syswrite(SecureRandom.uuid)
    end
  end

  def benchmark(file, count)
    start = Time.now
    yield
    file.write("#{count},#{(Time.now - start)}\n")
  end
end
