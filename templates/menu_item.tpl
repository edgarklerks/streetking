<li>
	<div module='[:name]' class='menu_item'>[:name]</div> 
	<!--<span class="sub_menu">[:submenu]</span>-->
	<span class="sub_menu">
		[:repeat data:submenu as:menu] {
			<div module='[:name]_[:menu.name]' class='menu_item [:menu.class]'>[:menu.name]</div> 
		}
	</span>
</ul>