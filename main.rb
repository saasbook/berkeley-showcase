require 'httparty'
require 'json'
require 'sinatra'

# function that reads file and converts to json
def reloadInfo
  response = HTTParty.get('http://esaas-engagements.herokuapp.com/apps.json')
  if response.body.to_s.empty?
    raise RuntimeError.new("Cannot access projects catalog: #{response.error}")
  else
    JSON.parse(response.body)
  end
end

get '/' do #home page
  redirect to('/projects') # redirects to project page
end

get '/projects' do # projects page
  @projects = reloadInfo #reloads the information
  erb :"index.html" #sends the information to index.html (projects page)
end

get '/projects/:task' do #individual additional information pages
  @task = params[:task] #the value of task (represents whatever went after the /)
  @projects = reloadInfo # reloads the information
  erb :"infopage.html" #sends the information and the value of task to infopage.html (extra info page)
end

get '/info' do # info page
  File.read(File.join('views', 'websiteinfo.html')) #opens up the home page
end

post '/projects' do
  @projects = reloadInfo
  # keep only those projects where the name, description, or org name
  # match the search terms (ignoring case).
  @search =  params[:searchtext].to_s.strip.downcase
  @projects.select! do |project|
    project['name'].to_s.downcase.include?(@search) ||
      project['description'].to_s.downcase.include?(@search) ||
      project['org']['name'].to_s.downcase.include?(@search)
  end
  erb :"index.html" #sends the information to index.html (projects page)
end

