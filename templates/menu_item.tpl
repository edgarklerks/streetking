[:repeat data:nodes as:menu] {
<li>
    [:when (menu.content.SubMenu)]{
	<div module='[:menu.content.SubMenu.1]' class='menu_item [:menu.content.SubMenu.2]'>[:menu.content.SubMenu.0]</div> 
	}
	[:when (menu.content.MenuItem)]{
		<div module='[:menu.content.MenuItem.1]' class='menu_item [:menu.content.MenuItem.2]'>[:menu.content.MenuItem.0]</div> 
	}
	<span class="sub_menu">

		[:repeat data:menu.nodes as:submenu] {
			<div module='[:submenu.content.MenuItem.1]' class='menu_item [:submenu.content.MenuItem.2]'>[:submenu.content.MenuItem.0]</div>  
		}
	</span>
</li>
}