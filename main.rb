require 'google_drive'
require 'json'
require 'sinatra'


session = GoogleDrive.saved_session("config.json")
# get important information such as user password and username etc.
ws = session.spreadsheet_by_key("1FnllGoYuUjhdF1xF1kQRIrWrv_znxqokSq84-uNw8wY").worksheets[1]
# connects to the specific spreadsheet and page 2 of it

# function that takes in the row number and the google sheet and returns a hash filled with the project's info
def getHash (number, ws)
    holder = Hash.new #place holder hash
   
   (1..ws.num_cols).each do |letter| # for each column (letter)
       if (ws[number, letter] != "") then # if not empty
           holder[ws[1, letter]] =  ws[number, letter] #hash is filled in with important info
           
       else
            holder[ws[1, letter]] =  "No known information" #hash is filled in with a string saying no info
       end
       
    end

    return holder # returns the filled hash

end

# function that takes in the sheet, calls getHash to get filled hashes and then adds them to an array as json objects which it eventually returns
def reloadInfo (ws)
    i = 0
    holder = [] # placeholder array
    
    (2..ws.num_rows).each do |number| # for each row
        holder[i] = getHash(number, ws).to_json #call the getHash function and convert return value to json
        i = i + 1;
    end
    
    return holder
end

get '/' do #home page
    File.read(File.join('views', 'home.html')) #opens up the home page
end

get '/projects' do # projects page
    @new_holder = reloadInfo(ws) #reloads the information
    erb :"index.html" #sends the information to index.html (projects page)
end

get '/projects/:task' do #individual additional information pages
    @task = params[:task] #the value of task (represents whatever went after the /)
    @new_holder = reloadInfo(ws) # reloads the information
    erb :"infopage.html" #sends the information and the value of task to infopage.html (extra info page)
end

post '/projects' do
    @new_holder = reloadInfo(ws) #reloads the information
    @values =  params[:text]
    erb :"index.html" #sends the information to index.html (projects page)
end

