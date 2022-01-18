require './cell'

module GOL
  class Board

    COMPONENTS = 2 # Bidimensional... for now
    RADIUS = 1 # Neighborhood radius

    def initialize(options)
      raise 'Invalid value for rows' unless valid_integer(options[:rows])

      @rows = options[:rows]

      raise 'Invalid value for columns' unless valid_integer(options[:columns])

      @columns = options[:columns]

      @space = Array.new(@rows) { |row_index| Array.new(@columns) { |column_index| Cell.new([row_index, column_index]) } }
    end

    def play
      @space.flatten.each do |cell|
        alive_neighbors = neighbors_of(cell).select(&:alive?).count
        # Rules
        # 1. Any live cell with fewer than two live neighbours dies, as if by underpopulation.
        cell.die! && next if cell.alive? && alive_neighbors < 2

        # 2. Any live cell with two or three live neighbours lives on to the next generation.
        next if cell.alive? && [2, 3].include?(alive_neighbors)

        # 3. Any live cell with more than three live neighbours dies, as if by overpopulation.
        cell.die! && next if cell.alive? && alive_neighbors > 3

        # 4. Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
        cell.revive! if cell.dead? && alive_neighbors == 3
      end
    end

    def cell_at(coordinates)
      components.reduce(@space) do |subspace, component|
        coordinate = coordinates[component]
        subspace = subspace[coordinate]
      end
    end

    def neighbors_of(cell)
      neighbor_coordinates_of(cell).map { |coordinates| cell_at(coordinates) }.compact
    end

    def to_a
      @space.map { |row| row.map(&:alive?) }
    end

    def to_json(*_args)
      to_a.to_json
    end

    private

    def neighbor_coordinates_of(cell)
      coordinates = cell_distances.reduce([]) do |memo, row_distance|
        cell_distances.each do |column_distance|
          coordinates = cell.coordinates
          neighbor_coordinates = [coordinates.first + row_distance, coordinates.last + column_distance]
          memo << neighbor_coordinates unless out_of_range?(neighbor_coordinates)
        end
        memo
      end

      coordinates - [cell.coordinates]
    end

    def cell_distances
      @cell_distances ||= (-RADIUS..RADIUS).to_a
    end

    # [0, 1] for bidimensional
    def components
      @components ||= (0...COMPONENTS).to_a
    end

    def size
      @size ||= [@rows, @columns]
    end

    def out_of_range?(coordinates)
      components.any? { |component| coordinates[component].negative? || coordinates[component] >= size[component] }
    end

    def valid_integer(value)
      value.is_a?(Integer) && value.positive?
    end
  end
end