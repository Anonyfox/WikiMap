#    GraphvizSimple.rb - A Very Simple Ruby Interface to Graphviz
#    Copyright (C) 2008  Matt Savona (http://www.loopforever.com)
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

# You should know that the purpose of this class is to act as an extremely 
# loose interface to Graphviz. It does not contain much error checking or
# handling. If you improve upon this, please reach me at http://loopforever.com
# and I will gladly add a link to your version.

# Sample usage:
# See http://www.graphviz.org/doc/info/attrs.html for available Graphviz attributes.

# require 'GraphvizSimple'
# g = GraphvizSimple.new("G")
# g.node_attributes = {"style" => "filled", "fillcolor" => "red", "shape" => "circle"}
# g.edge_attributes = {"arrowhead" => "none"}
# g.add_node("a", {"label" => "Root Node"})
# g.add_node("b")
# g.add_node("c", {"label" => ['< <table border="1"><tr><td>In a cell</td></tr></table> >', :no_quotes]})
# g.add_edge("a", "b")
# g.add_edge("a", "c")
# g.output("my_graph.png", "png")

class GraphvizSimple
  GRAPHVIZ_BIN_PATH = '/usr/bin' # don't include trailing slash
  
  attr_accessor :graph_name,
                :graph_attributes,
                :node_attributes,
                :edge_attributes,
                :render_mode,
                :output_type,
                :output_file
                
  attr_reader :node_list,
              :edge_list
  
  # Create a new instance of GraphvizSimple
  def initialize(graph_name, graph_attributes = {}, node_attributes = {}, edge_attributes = {})
    @graph_name = graph_name
    @graph_attributes = graph_attributes
    @node_attributes = node_attributes
    @edge_attributes = edge_attributes

    @node_list = {}
    @edge_list = []
  end
  
  # Add a new node to the graph
  # - name: A unique name for this node
  # - node_attributes (optional): Key-value hash of attributes specific to this node
  def add_node(name, node_attributes = {})
    if node_list.has_key?(name)
      raise "The node '#{name}' already exists in the node list."
    end
    
    @node_list[name] = node_attributes
  end
  
  # Add a new edge to the graph
  # - from_node: The name of the existing node to start the edge from
  # - to_node: The name of the existing node to end the edge at
  def add_edge(from_node, to_node)
    if !node_list.has_key?(from_node)
      raise "The node '#{from_node}' does not exist in the node list, you need to add it first."
    end
    
    if !node_list.has_key?(to_node)
      raise "The node '#{to_node}' does not exist in the node list, you need to add it first."
    end
    
    @edge_list << {:from_node => from_node, :to_node => to_node}
  end
  
  # Output this graph to a file.
  # - output_file: The name of the file to write to, including path, if any.
  # - output_type (optional): The type of file to output as.
  # - render_mode (optional): The Graphviz program to execute.
  # - args (optional): Additional command line arguments to run Graphviz with, in the form of an Array.
  def output(output_file, output_type = "png", render_mode = "circo", args = [])
    @render_mode = render_mode
    @output_type = output_type
    @output_file = output_file
    
    temp_file_path = output_file + ".gv.tmp"
    temp_file = File.new(temp_file_path, "w")
    temp_file.puts generate_markup
    temp_file.close
    
    if @output_type == "dot"
      File.rename(temp_file_path, output_file)
      return
    end
    
    addtl_args = args.join(" ")
    
    IO.popen("#{GRAPHVIZ_BIN_PATH}/#{render_mode} #{temp_file_path} -T#{output_type} -o #{output_file} #{addtl_args}") {| io |}

    File.unlink(temp_file_path)
  end
  
  private
  
  def generate_markup
    output_markup = ""
    output_markup += "digraph #{@graph_name} {\n"
    
    a = generate_attributes(@graph_attributes, "; ")
    output_markup += "  #{a}\n" unless a.empty?
    
    a = generate_attributes(@node_attributes)
    output_markup += "  node [#{a}]\n" unless a.empty?
    
    a = generate_attributes(@edge_attributes)
    output_markup += "  edge [#{a}]\n" unless a.empty?
    
    @node_list.each_pair do | key, value |
      output_markup += "  #{key} [#{generate_attributes(value)}];\n"
    end
    
    @edge_list.each do | edge |
      output_markup += "  #{edge[:from_node]} -> #{edge[:to_node]}\n"
    end
    
    output_markup += "}"
    
    return output_markup
  end
  
  def generate_attributes(attributes, seperator = ", ")
    ga = ""
    
    unless attributes.empty?
      ga = []
      
      attributes.each_pair do | key, value |
        no_quotes = false
        
        if value.kind_of?(Array)
            no_quotes = true if value.last == :no_quotes
            value = value.first
        end
        
        if no_quotes
          ga << "#{key} = #{value}"
        else
          ga << "#{key} = \"#{value}\""
        end
      end
      
      ga = ga.join(seperator)
    end
    
    return ga
  end
end