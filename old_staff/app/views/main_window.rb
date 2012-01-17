class MainWindow
	def initialize main_window
		@options_list
		@mind_map
		@search_field
		@main_window = main_window
		p main_window
		draw_window
	end
	
	def draw_window
		Rubeus::Swing.irb
		# the headline with search field and buttons
		title_pane = JPanel.new size: [1000, 50] do |pane|
			pane.layout = GridLayout.new 4, 1
			pane.border = BorderFactory.createEtchedBorder
			@search_field = JTextField.new columns: 10
			JButton.new(" search ") { nil }
			JButton.new(" export as image ") { nil }
			JButton.new(" another Button... ") { nil }
		end
		@main_window.add title_pane
	end

end