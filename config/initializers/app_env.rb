APP_ENV = {}
ENV.each do |key, value|
  APP_ENV[key] = value
end
GIT_PATH = `which git`.strip
