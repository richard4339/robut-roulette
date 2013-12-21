# A simple roulette module
class Robut::Plugin::Roulette
  include Robut::Plugin

  def usage
    [ "#{at_nick} roulette - takes a shot" ]
  end

  def handle(time, sender_nick, message)
    words = words(message)
    return if words.index("roulette").nil?

    if last_draw == sender_nick
      return reply "#{sender_nick}: you can't shoot twice in a row, dolt!"
    end

    outcome = draw
    stats(sender_nick, outcome)

    output = "Shot #{shot} of 6:"
    if outcome == 1
      reply "#{output} (boom)"
      reply "*reloads*"
      reset
    else
      reply "#{output} *click*"
    end
  end

  def roulette
    store["roulette"] ||= [0,0,0,0,0,1].shuffle
  end

  def game
    store["game"] ||= []
  end

  def shot
    6 - roulette.length
  end

  def draw
    roulette.pop unless roulette.empty?
  end

  def last_draw
    game.last unless game.empty?
  end

  def stats(user,outcome)
    game.push(user)
  end

  def reset
    store["roulette"] = [0,0,0,0,0,1].shuffle
    store["game"] = []
  end

end