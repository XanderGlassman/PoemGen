require "engtagger"
require "set"

class Poem
  attr_reader :model_tags, :model_full, :word_bank
  attr_accessor :text

  #NOTE a tag is a is a reference to a word's part of speech, named in engtagger. 
  def initialize(model_sentence, bank)
    @tagger = EngTagger.new
    @model_sentence = model_sentence
    @model_tags = @tagger.get_readable(model_sentence).gsub(/\w*\//, "").downcase
    @model_full = @tagger.get_readable(model_sentence)
    @word_bank = @tagger.add_tags(bank)

  end

  def shuffle_word_bank
    word_bank.split.shuffle.to_set
  end

  #OPTMIZE
  def find_word(tag)   
    @tagger.strip_tags(self.shuffle_word_bank.find{|e|e.match("<#{tag}>")})
  end

  def first_gen
    self.model_tags.split.map{|tag| find_word(tag)}.join(' ').capitalize
  end
end

word_bank = 
  "
  Across the courtesy bay the white palaces of fashionable East Egg
  glittered along the water, and the history of the summer really begins
  on the evening I drove over there to have dinner with the Tom
  Buchanans. Daisy was my second cousin once removed and I'd known Tom
  in college. And just after the war I spent two days with them in
  Chicago.

  Her husband, among various physical accomplishments, had been one of
  the most powerful ends that ever played football at New Haven--a
  national figure in a way, one of those men who reach such an acute
  limited excellence at twenty-one that everything afterward savors of
  anti-climax. His family were enormously wealthy--even in college his
  freedom with money was a matter for reproach--but now he'd left Chicago
  and come east in a fashion that rather took your breath away: for
  instance he'd brought down a string of polo ponies from Lake Forest.
  It was hard to realize that a man in my own generation was wealthy
  enough to do that.

  Why they came east I don't know. They had spent a year in France, for no
  particular reason, and then drifted here and there unrestfully wherever
  people played polo and were rich together. This was a permanent move,
  said Daisy over the telephone, but I didn't believe it--I had no sight
  into Daisy's heart but I felt that Tom would drift on forever seeking
  a little wistfully for the dramatic turbulence of some irrecoverable
  football game.

  And so it happened that on a warm windy evening I drove over to East
  Egg to see two old friends whom I scarcely knew at all. Their house was
  even more elaborate than I expected, a cheerful red and white Georgian
  Colonial mansion overlooking the bay. The lawn started at the beach
  and ran toward the front door for a quarter of a mile, jumping over
  sun-dials and brick walks and burning gardens--finally when it reached
  the house drifting up the side in bright vines as though from the
  momentum of its run. The front was broken by a line of French windows,
  glowing now with reflected gold, and wide open to the warm windy
  afternoon, and Tom Buchanan in riding clothes was standing with his
  legs apart on the front porch.

  He had changed since his New Haven years. Now he was a sturdy, straw haired
  man of thirty with a rather hard mouth and a supercilious manner.
  Two shining, arrogant eyes had established dominance over his face and
  gave him the appearance of always leaning aggressively forward. Not
  even the effeminate swank of his riding clothes could hide the enormous
  power of that body--he seemed to fill those glistening boots until he
  strained the top lacing and you could see a great pack of muscle
  shifting when his shoulder moved under his thin coat. It was a body
  capable of enormous leverage--a cruel body.

  Instead of taking the short cut along the Sound we went down the road and
  entered by the big postern. With enchanting murmurs Daisy admired this
  aspect or that of the feudal silhouette against the sky, admired the
  gardens, the sparkling odor of jonquils and the frothy odor of hawthorn
  and plum blossoms and the pale gold odor of kiss-me-at-the-gate.
  It was strange to reach the marble steps and find no stir of bright
  dresses in and out the door, and hear no sound but bird voices in the
  trees.

  And inside as we wandered through Marie Antoinette music rooms and
  Restoration salons I felt that there were guests concealed behind
  every couch and table, under orders to be breathlessly silent until we
  had passed through. As Gatsby closed the door of \"the Merton College
  Library\" I could have sworn I heard the owl-eyed man break into
  ghostly laughter.

  We went upstairs, through period bedrooms swathed in rose and lavender
  silk and vivid with new flowers, through dressing rooms and poolrooms,
  and bathrooms with sunken baths--intruding into one chamber where a
  dishevelled man in pajamas was doing liver exercises on the floor. It
  was Mr. Klipspringer, the \"boarder.\" I had seen him wandering hungrily
  about the beach that morning. Finally we came to Gatsby's own apartment,
  a bedroom and a bath and an Adam study, where we sat down and drank a
  glass of some Chartreuse he took from a cupboard in the wall.

  He hadn't once ceased looking at Daisy and I think he revalued
  everything in his house according to the measure of response it drew
  from her well-loved eyes. Sometimes, too, he stared around at his
  possessions in a dazed way as though in her actual and astounding
  presence none of it was any longer real. Once he nearly toppled down a
  flight of stairs.

  His bedroom was the simplest room of all--except where the dresser was
  garnished with a toilet set of pure dull gold. Daisy took the brush
  with delight and smoothed her hair, whereupon Gatsby sat down and
  shaded his eyes and began to laugh. runs loves hates sprints

  He took out a pile of shirts and began throwing them, one by one
  before us, shirts of sheer linen and thick silk and fine flannel
  which lost their folds as they fell and covered the table in
  many-colored disarray. While we admired he brought more and the soft
  rich heap mounted higher--shirts with stripes and scrolls and plaids in
  coral and apple-green and lavender and faint orange with monograms of
  Indian blue. Suddenly with a strained sound, Daisy bent her head into
  the shirts and began to cry stormily."

# poem = Poem.new('Once he nearly toppled down a flight of stairs.', word_bank)
# t1 = Time.now
# p poem.first_gen
# t2 = Time.now

# p t2 - t1