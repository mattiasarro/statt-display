class Event
  include Mongoid::Document
  
  # Use the SnowPlow structure for organizing data.
  # Currently only support the basic date/time/users/page loads
  
  # Last update: SnowPlow 0.5.0                 *  Always present
  
  # Date/time
  field :dt                               # *  date
  field :tm                               # *  time
                                               
  # Transaction                                
  field :txn_id                           # *  A unique event ID. If two or more records have the same txn_id, one is a duplicate record
                                               
  # User and visit                             
  field :user_id                          # *  A unique ID assigned to each browser and stored on the SnowPlow cookie.
  field :user_ipaddress                   # *  Visitor IP Address
  field :visit_id, type: Integer          # *  A counter that indicates what visit this is for this particular user_id i.e. 1 if this is a user’s first visit, 2 if it is his / her 2nd visit
                                               
  # Page                                       
  field :page_url                         # *   
  field :page_title                       #    
  field :page_referrer                    # *  The referrer URL. If this is the first page view of a session, it points at the referrering website / search engine if applicable
  
  # # Event                                      
  # field :ev_category                      #    The category of event e.g. ‘ecomm’, ‘media’
  # field :ev_action                        #    The action performed e.g. ‘play-video’, ‘add-to-basket’
  # field :ev_label                         #    A label associated with the event / action. This is often set to the object and action is performed on e.g. the product_id of the item added-to-basket, or the ID of the video played
  # field :ev_property                      #    A property associated with the event / action. This might be the number of seconds into a video play starts, or the quantity of an item added to basket
  # field :ev_value                         #    A value associated with with the action e.g. the value of the items added to basket
  #                                              
  # # Marketing                                  
  # field :mkt_medium                       #    The type of ad used e.g. cpc, banner, email, affiliate…
  # field :mkt_source                       #    The source of the ad: used e.g. Google, MSN, Facebook, TradeDoubler
  # field :mkt_term                         #    Any keywords associated with the ad. This is relevant for search ads  
  # field :mkt_content                      #    The content of the ad, or a reference to the creative ID. Used e.g. to compare the results within a campaign between different creatives.  
  # field :mkt_campaign                     #    The campaign name. A single campaign may involve ads on multiple sources / mediums, so mkt_campaign is often a way of grouping them together into a single marketing initiative
  #                                                                                             
  # # Transaction                                
  # field :tr_orderid                       #    The ID of this order
  # field :tr_affiliation                   #    The affiliate or store name
  # field :tr_total                         #    The total paid
  # field :tr_tax                           #    The tax paid
  # field :tr_shipping                      #    The shipping paid
  # field :tr_city                          #    The buyer’s city
  # field :tr_state                         #    The buyer’s state or province
  # field :tr_country                       #    The buyer’s country
  #                                              
  # # Transaction Item                           
  # field :ti_orderid                       #    The ID of the order which this item belongs to
  # field :ti_sku                           #    The product SKU for this item
  # field :ti_name                          #    The product name for this item
  # field :ti_category                      #    The category this item belongs to
  # field :ti_price                         #    The unit price for this item
  # field :ti_quantity                      #    The quantity of this item purchased
  #                                              
  # # Browser                                    
  # field :br_name                          #    Browser name e.g. Internet Explorer
  # field :br_family                        #    Browser family e.g. Chrome
  # field :br_version                       #    Browser version
  # field :br_type                          #    Browser, robot
  # field :br_renderengine                  #    Browser rendering engine e.g. GECKO, WEBKIT
  # field :br_lang                          # *  Language that the browser is set to
  # field :br_features, type: Array         #    Contains a set of all features supported by this browser, e.g. fla for Flash, pdf for PDF support
  # field :br_cookies, type: Boolean        # *  Flag set to ‘true’ if browser permits cookies
  #                                              
  # # Operating system                           
  # field :os_name                          #    Operating system name e.g. Windows
  # field :os_family                        #    Operating system family e.g. Android
  # field :os_manufacturer                  #    Operating system manufacturer e.g. Apple Inc., Google Inc.
  #                                              
  # # Device/hardware                            
  # field :dvce_type                        #    Device type e.g. computer, mobile…
  # field :dvce_ismobile, type: Boolean     #    Flag set if user is browsing on a mobile device
  # field :dvce_screenwidth, type: Integer  # *  Screenwidth in pixels
  # field :dvce_screenheight, type: Integer # *  Screenheight in pixels
  #                                              
  # # Application                                
  # field :app_id                           #    The ID for the application or site
  
end