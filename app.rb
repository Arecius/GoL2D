require 'colorize'
require './game.rb'


# Whose responsibility is the next turn/generation ?
# What does a cell should do ?
#   Should the neighbor count be the Cell or the board responsibility.. why ?
#     Letting the cell count would be a more elegant solution but,
#     This would allow for cyclical references with tend to be a bad idea around garbage collectors
# Should the board really be an Array..?
#   Using a morre complex data structure could prove useful like a winged edge mesh along with a alive cells array..
#   This implies "way more" memory but faster processing traversing neighbors and counting and counting become trivial
#   Winged edge meshes act like doubly linked list allowing the traversal of the mesh nodes...
# How could we limit the next generation proccesing to live cells ?
#   Would this be better ? Complexity vs Readability
# How could we manually seed the board ?
game = GOL::Game.new
game.configure
game.start
