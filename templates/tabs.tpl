<div>
	<span id="tabs">
		<ul>
			[:repeat data:tabs as:tab] {
				<li><a module='[:tab.module]' class='menu_item [:tab.class]' href="#[:tab.module]">[:tab.name]</a></li>
			}
		</ul>
		<div></div>
		<div id="PARTS" style="background:#f00">
		</div>
	</span>
</div>
