require 'google_drive'
require 'json'
require 'sinatra'
# TODO - change to read from url instead of local file
file = File.read('/Users/rushil/Desktop/berkeley-showcase-master/info_sheets.json')


# function that reads file and converts to json
def reloadInfo (file)
    data_hash = JSON.parse(file) #convert the json to a Hash (data_hash is an array of hashes
    
    data_hash.each do |item|
        item.each do |key, value|
            if (value.nil? or value == "") then
                item[key] = "No known information"
            end
            
        end
        
    end

   return data_hash
end

get '/' do #home page
   redirect to('/projects') # redirects to project page
end

get '/projects' do # projects page
    @new_holder = reloadInfo(file) #reloads the information
    erb :"index.html" #sends the information to index.html (projects page)
end

get '/projects/:task' do #individual additional information pages
    @task = params[:task] #the value of task (represents whatever went after the /)
    @new_holder = reloadInfo(file) # reloads the information
    erb :"infopage.html" #sends the information and the value of task to infopage.html (extra info page)
end

get '/info' do # info page
    File.read(File.join('views', 'websiteinfo.html')) #opens up the home page
end

post '/projects' do
    @new_holder = reloadInfo(file) #reloads the information
    @values =  params[:text]
    erb :"index.html" #sends the information to index.html (projects page)
end
 
