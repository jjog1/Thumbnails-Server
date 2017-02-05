config      = require './config'
express     = require 'express'
fileUpload  = require 'express-fileupload'
path        = require 'path'
sharp       = require 'sharp'
sizeOf      = require 'image-size'

app = express()

app.use fileUpload()
app.listen(4000)

console.log '*****************'
console.log 'server is running post: 4000'
console.log '*****************'

# Root http://localhost:4000/
app.get '/', (req, res) ->
    res.sendFile path.join(__dirname + '/../index.html')

# Update load post request http://localhost:4000/upload
app.post '/upload', (req, res) ->
    sampleFile = req.files.sampleFile

    return res.send 'success' unless sampleFile?

    uploadedImagePath = config.paths.imageRoot + "/#{sampleFile.name}"
    imageThumbnailPath = config.paths.thumbnailRoot + "/#{sampleFile.name}"

    # Move the uploaded image to the destination directory
    sampleFile.mv uploadedImagePath, (fileMoveError) ->
        if fileMoveError
            # If an error occured don't make a thumbnail
            console.log fileMoveError
            return res.send fileMoveError
        # After the file has been moved start generating the thumbnail
        imageDimensions = sizeOf uploadedImagePath

        # Sharp allows us to resize an image and copy the resize to a new location.
        sharp(uploadedImagePath)
        .resize Math.round(imageDimensions.width/2), Math.round(imageDimensions.height/2)
        .toFile imageThumbnailPath, (error) ->
            console.log error

    res.send 'success'