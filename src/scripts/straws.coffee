# Allows you to host a 'drawing straws' session in Hubot
#
# How do I begin?
# 1. use the 'straw begin' command to start or reset a new session
# 2. Everyone who is to participate uses the 'draw straw|ds' command
# 3. Once everyone has participated then 'straw end' to see who won (or lost)
#
# straw begin - starts/resets a drawing straws session
# draw straw | ds - Adds you to the current hand
# draw add <any string/name> - Adds the specified <string/name> to the list of participants.
# straw end - Tallies all the participating users and prints a report with each user's hand

module.exports = (robot) ->
  participants = {}
  userDraw = (userName) ->
    maxUserLength = 0
    (maxUserLength = key.length if key.length > maxUserLength) for key of participants
    padding = new Array(maxUserLength - userName.length + 1).join(' ')
    str = userName + padding + ' |' + new Array(Math.floor(Math.random()*20) + 1).join('=')
    str
    
  robot.respond /(draw straw|drawstraw|ds)/i, (msg) ->
    userName = msg.message.user.name
    participants[userName] = true
    msg.send('User [' + userName + '] drew a straw.')

  robot.respond /straw add (.*)/i, (msg) ->
    userName = msg.match[1]
    participants[userName] = true
    msg.send('User [' + userName + '] drew a straw.')


  robot.respond /straw begin/i, (msg) ->
    participants = {}
    msg.send("Ok everybody! Let's draw some straws.\n To participate enter command [draw straw|ds]")

  robot.respond /straw end/i, (msg) ->
    p = []
    (p.push(userDraw(key))) for key, value of participants
    if p.length
      rtnMsg = p.join('\n')
      msg.send('\n' + rtnMsg)
    else
      msg.send('Nobody participated in this last hand. :(');
      
