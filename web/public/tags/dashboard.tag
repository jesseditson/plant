var pubnub = require('../javascripts/lib/pubnub')
var request = require('superagent')


<dashboard>

  <div class="dashboard container">

    <header class="container">
      <div class="info">
        <div class="avatar">
          <img src="images/avatar.jpg" width="90" height="90">
        </div>
        <span class="name">AlvinCado</span><br>
        <span class="locations">San Francisco, CA</span>
      </div>
    </header>

    <panel each='{ panels() }' data='{ this }'></panel>

    <footer>
      <ul>
        <li class="home"></li>
        <li class="gallery"></li>
        <li class="settings"></li>
    </footer>
  </div>

  var self = this
  this.panels = function(){
    return Object.keys(self.dataTypes).map(function(type) {
      var d = self.dataTypes[type]
      d.title = type
      return d
    })
  }
  this.dataTypes = {}
  this.on('mount', function() {
    console.log('subscribing to plant:datapoint updates')
    pubnub.subscribe({
      channel: 'plant:datapoint',
      callback: function(data) {
        self.dataTypes[data.type] = {
          value: data.value,
          time: new Date()
        }
        self.update()
      }
    })
  })

  // bootstrap our data
  request
    .get('/api/data-points/current')
    .end(function(err, res) {
      if (err) throw err
      self.dataTypes = res.body
      self.update()
    })

</dashboard>
