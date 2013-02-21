{{ for(var i = 0; i < sk.nodes.length; i++) { }}
	{{? "SubMenu" in sk.nodes[i].content }}
		<li class="li-main-menu-item">
			<div module="{{=sk.nodes[i].content.SubMenu[1] }}" class="menu_item main-menu-item menu-{{= sk.nodes[i].content.SubMenu[0] }} {{= sk.nodes[i].content.SubMenu[2] }}">{{= sk.nodes[i].content.SubMenu[0] }}</div>

	{{?? "MenuItem" in sk.nodes[i].content }}
		<li class="li-main-menu-item">
			<div module="{{=sk.nodes[i].content.MenuItem[1] }}" class="menu_item main-menu-item menu-{{= sk.nodes[i].content.MenuItem[0] }} {{= sk.nodes[i].content.MenuItem[2] }}">{{= sk.nodes[i].content.MenuItem[0] }}</div>
	{{?? sk.nodes[i].nodes.length > 0 }}
		<div class="sub-menu-container">
			<ul class="sub-menu">
			</ul>
		</div>			
	{{?}}
{{ } }}
</li>





<!--
[:repeat data:nodes as:menu] {
[:when (menu.content.SubMenu)]{
	<li class="li-main-menu-item">
		<div module="[:menu.content.SubMenu.1]" class="menu_item main-menu-item menu-[:menu.content.SubMenu.0] [:menu.content.SubMenu.2]">[:eval CAPITALISEFIRSTLETTER(menu.content.SubMenu.0)]</div>
}
[:when (menu.content.MenuItem)]{
	<li class="li-main-menu-item">
		<div module="[:menu.content.MenuItem.1]" class="menu_item main-menu-item menu-[:menu.content.MenuItem.0] [:menu.content.MenuItem.2]">[:eval CAPITALISEFIRSTLETTER(menu.content.MenuItem.0)]</div>
}
[:when (menu.nodes.0)]{
	<div class="sub-menu-container">
		<ul class="sub-menu">
			[:repeat data:menu.nodes as:submenu] {
				<li class="li-sub-menu-item" module="[:submenu.content.MenuItem.1]">
					<div class="menu_item [:submenu.content.MenuItem.2]">[:submenu.content.MenuItem.0]</div>  
				</li>
			}
		</ul>
	</div>
}
</li>
}
-->