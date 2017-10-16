import flask

myJson = [{
          "name": "Northtown",
          "Latitude":45.126970,
          "Longitude":-93.264415
          },
          {
          "name": "Foley Park and Ride",
          "Latitude":45.142311,
          "Longitude":-93.285325
          }]
app = flask.Flask(__name__)
@app.route("/")
def index():
    return flask.redirect("ihrca.info",code=302)

@app.route("/api/",methods=["GET"])
def dumbReturn():
    return flask.jsonify(myJson)

if __name__ == '__main__':
    app.run(host="0.0.0.0",port=8080)
