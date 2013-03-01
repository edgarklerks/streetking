{{? 'nodes' in sk }}
    {{ for(var i = 0; i < sk.nodes.length; i++) { }}
        {{? "SubMenu" in sk.nodes[i].content }}
            <div class="main-menu-item-container">
                <div class="main-menu-item-container-inner">
                    <div class="main-menu-item-box">
                        <div class="main-menu-item-box-inner main-menu-{{= sk.nodes[i].content.SubMenu[0].toLowerCase() }}">
                            <div class="main-menu-item-title">{{= sk.nodes[i].content.SubMenu[0] }}</div>
                        </div>
                        {{? sk.nodes[i].nodes.length > 0 }}
                            <div class="main-menu-item-submenu-container">
                                {{ for(var j = 0; j < sk.nodes[i].nodes.length; j++) { }}
                                    {{? j > 0 }}
                                        <div class="sk-gradient-line-both">&nbsp;</div>
                                    {{? }}
                                    <div class="submenu-item" module="{{= sk.nodes[i].nodes[j].content.MenuItem[1] }}">{{= sk.nodes[i].nodes[j].content.MenuItem[0] }}</div>  
                                {{ } }}
                            </div>
                        {{?}}
                    </div>
                </div>
            </div>
        {{?? "MenuItem" in sk.nodes[i].content && sk.nodes[i].content.MenuItem[0].toLowerCase() !== 'home'}}
            <div class="main-menu-item-container">
                <div class="main-menu-item-container-inner" module="{{=sk.nodes[i].content.MenuItem[1] }}">
                    <div class="main-menu-item-box">
                        <div class="main-menu-item-box-inner main-menu-{{= sk.nodes[i].content.MenuItem[0].toLowerCase() }}">
                            <div class="main-menu-item-title">{{= sk.nodes[i].content.MenuItem[0] }}</div>
                        </div>
                    </div>
                </div>
            </div>
        {{?}}
    {{ } }}
{{? }}
