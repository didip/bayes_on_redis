Gem::Specification.new do |gem|
  gem.name    = 'bayes_on_redis'
  gem.version = "0.1.9"
  gem.date    = Date.today.to_s

  gem.summary = "Bayesian filter on top of Redis"
  gem.description = "bayes_on_redis library provides bayesian classification on a given text similar to many SPAM/HAM filtering."

  gem.authors  = ['Didip Kerabat']
  gem.email    = 'didipk@gmail.com'
  gem.homepage = 'https://github.com/didip/bayes_on_redis'

  gem.rubyforge_project = nil
  gem.has_rdoc = false

  gem.files = ["README.markdown", File.join("lib", "bayes_on_redis.rb"), File.join("datasets", "stopwords.txt")]
end
