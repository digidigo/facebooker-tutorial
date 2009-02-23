module AdminHelper
      # Create a multi-list table
      # <em> See: </em> http://wiki.developers.facebook.com/index.php/Facebook_Styles for details  
      #
      # You must call fb_css() to include the css styles.  You can include the css by
      # putting <%= fb_css() %> in your layout.
      #
      # Inside use helper methods: fb_tr, fb_td, fb_first_list_item, 
      #                            fb_list_item, fb_th, fb_tf,  
      #                            fb_th_spacer, fb_td_spacer,  fb_tf_spacer.
      #
      # For example (modeled after the basic code on the facebook wiki),
      #  
      #  <% fb_table do %>
      #    <% fb_tr do %>
      #      <%= fb_th("List 1", "#", "See All") %>
      #      <%= fb_th_spacer%>
      #      <%= fb_th("List 2", "#", "See All") %>
      #    <% end %>
      #    <% fb_tr do %>
      #      <% fb_td do %>
      #        <% fb_first_list_item do %>
      #           INSERT FIRST ITEM HERE
      #        <% end %>            
      #        <% fb_list_item do %>
      #           INSERT ANOTHER ITEM HERE
      #        <% end %>
      #      <% end %>
      #      <%= fb_td_spacer %>
      #      <% fb_td do %>
      #        <% fb_first_list_item do %>
      #           INSERT FIRST ITEM HERE
      #        <% end %>            
      #        <% fb_list_item do %>
      #           INSERT ANOTHER ITEM HERE
      #        <% end %>
      #      <% end %>
      #    <% end %>    
      #    <% fb_tr do %>
      #      <%= fb_tf("#", "See all List 1's") %>
      #      <%= fb_tf_spacer%>
      #      <%= fb_tf("#", "See all List 2's") %>
      #    <% end %>
      #  <% end %>
      def fb_table(options={}, &block)
        options.merge!(:class=>"lists",:cellspacing=>"0", :border=>"0")
        content = capture(&block)
        content_tag(:div,
          concat(content_tag(:table, content,stringify_vals(options) ),
            block.binding
          )
        )
      end

      # Include styles that are used by Facebook.
      # Best to include in your layout with your other css.
      # Required for fb_table.  See the example there.
      # <em> See: </em> http://wiki.developers.facebook.com/index.php/Facebook_Styles for more details  
      def fb_css
        '<style>
        .lists th {
             text-align: left;
             padding: 5px 10px;
             background: #6d84b4;
        }

        .lists .spacer {
             background: none;
             border: none;
             padding: 0px;
             margin: 0px;
             width: 10px; 
        }

        .lists th h4 { float: left; color: white; }
        .lists th a { float: right; font-weight: normal; color: #d9dfea; }
        .lists th a:hover { color: white; }

        .lists td {
             margin:0px 10px;
             padding:0px;
             vertical-align:top;
        }

        .lists .list {
             background:white none repeat scroll 0%;
             border-color:-moz-use-text-color #BBBBBB;
             border-style:none solid;
             border-width:medium 1px;
        }
        .lists .list .list_item { border-top:1px solid #E5E5E5; padding: 10px; }
        .lists .list .list_item.first { border-top: none; }

        .lists .see_all {
             background:white none repeat scroll 0%;
             border-color:-moz-use-text-color #BBBBBB rgb(187, 187, 187);
             border-style:none solid solid;
             border-width:medium 1px 1px;
             text-align:left;
        }

        .lists .see_all div { border-top:1px solid #E5E5E5; padding:5px 10px; }
        
        </style>'       
      end

      # Render a facebook styled tr tag.
      # Use this in conjunction with fb_table.
      # Provide any options you like.
      def fb_tr(&block)
        content = capture(&block)
        concat(content_tag(:tr,content),block.binding)
      end
        
      # Render a facebook styled td tag.
      # Use this in conjunction with fb_table.
      # Provide any options you like.  The default options
      # include {:style=>"width:306px"}, the perfect width for
      # a two list table.  If you use options or want a 
      # different width, reset the style accordingly.
      def fb_td(options={:style=>"width:306px"},&block)
        options.merge!(:class=>"list")
        content = capture(&block)
        concat(content_tag(:td,content,stringify_vals(options)), block.binding)
      end

      # Render a facebook styled first list element.
      # Use this in conjunction with fb_table.  See the example there.
      # This first element has no padding above it.
      # Provide any options you like.
      def fb_first_list_item(options={},&block)
        content = capture(&block)
        options.merge!(:class=>'list_item.first clearfix')
        concat(content_tag(:div,content,stringify_vals(options)),block.binding)
      end

      # Render a facebook styled list element.
      # Use this in conjunction with fb_table.  See the example there.
      # Unlike the first element, this element has padding above it.
      # Provide any options you like.
      def fb_list_item(options={}, &block)
        content = capture(&block)
        options.merge!(:class=>'list_item clearfix')
        concat(content_tag(:div,content,stringify_vals(options)),block.binding)
      end
  
      # Renders a facebook styled table header.
      # Use this in conjunction with fb_table.  See the example there.
      # Provide a title for the list, a url, a label for that url, and any options.
      def fb_th(title,url,label, options={} )
        options.merge!(:href=>url)
        content_tag(:th,content_tag(:h4,title)+ 
            content_tag(:a,label,stringify_vals(options))
        ) 
      end

      # Renders a facebook styled table footer.
      # Use this in conjunction with fb_table.  See the example there.
      # Provide a url,a label for that url, and any options
      # for the td tag and/or the a tag.
      def fb_tf(url, label,td_options={},a_options={})
        td_options.merge!(:class=>"see_all")
        a_options.merge!(:href=>url)
        content_tag(:td,
          content_tag(:div,
            content_tag(:a,label,stringify_vals(a_options)) 
          ), stringify_vals(td_options)
        )
      end

      # Renders a facebook styled spacer for between calls to fb_th.
      # Use this in conjunction with fb_table.  See the example there.
      # Provide any options.
      def fb_th_spacer(options={})
        options.merge!(:class=>"spacer")
        tag(:th, stringify_vals(options))
      end

      # Renders a facebook styled spacer for between calls to fb_td.
      # Use this in conjunction with fb_table.  See the example there.
      # Provide any options.
      def fb_td_spacer(options={})
        options.merge!(:class=>"spacer")
        tag(:td, stringify_vals(options))
      end

      # Renders a facebook styled spacer for between calls to fb_tf.
      # Use this in conjunction with fb_table.  See the example there.
      # Provide any options.
      def fb_tf_spacer(options={})
        fb_td_spacer(options)
      end
     
end
