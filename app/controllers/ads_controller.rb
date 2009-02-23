class AdsController < ApplicationController
  
  caches_page :adsense, :google, :social_media, :rotate
  
  def adsense
    
    advert =      '<script type="text/javascript"><!--
       google_ad_client = "pub-6979873404821820";
       /* 468x60, created 4/17/08 */
       google_ad_slot = "9553164414";
       google_ad_width = 468;
       google_ad_height = 60;
       //-->
       </script>
       <script type="text/javascript"
         src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
        </script>'
     
    render :text => "<html> <body> #{advert} </body> </html>"
  end
 
  
  def google
    
  end
  
  
  def self.init_outline(outline)
    section_name = "Ads"
    outline.add_lesson(section_name, "Google Adsense", 
      {:controller => "ads", :action => "google"},"This lesson explains how to integrate Google ads into your site. <br/> 
       As you can see here the tutorial application uses Google adsense in the layout below. Google ads are typically very straight forward however when integrated into Facebook you will need to create
and iframe for the ad unit.  Some people are concerned that Google won't be able to provide context relevant ads,  I have done this type integration on another Facebook app and it appears to work just fine and within about 20
minutes of a page being created the ads becomes relevant to the content.")
    
    outline.add_lesson(section_name, "SocialMedia ", 
      {:controller => "ads", :action => "social_media"},"This lesson explains how to integrate Social Media ads into your application. <br/> 
       As you can see , the tutorial application uses ads for other Facebook applications at the bottom of the layout.  These ads are very common among application delvelopers as they can provide a strong revenue stream.  This is especially true if you do not have specific enough content for Google Adsense to provide relevant ads.")
    
    outline.add_lesson(section_name, "Rotate Your Ads ", 
      {:controller => "ads", :action => "rotate"},"This lesson explains how to rotate different ads. <br/> 
       Many developers on the Facebook Developers forum talk about how different ad networks will fail for an afternoon.  One way to protect yourself from this failure is to rotate your ads so that a single failure will cease your revenue stream.")
    end
end
