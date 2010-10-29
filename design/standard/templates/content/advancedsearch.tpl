{def $search=false()}
{if $use_template_search}
    {set $page_limit=10}
    {switch match=$search_page_limit}
    {case match=1}
        {set $page_limit=5}
    {/case}
    {case match=2}
        {set $page_limit=10}
    {/case}
    {case match=3}
        {set $page_limit=20}
    {/case}
    {case match=4}
        {set $page_limit=30}
    {/case}
    {case match=5}
        {set $page_limit=50}
    {/case}
    {/switch}
    {set $search=fetch(content,search,
                      hash(text,$search_text,
                           section_id,$search_section_id,
                           subtree_array,$search_sub_tree,
                           class_id,$search_contentclass_id,
                           class_attribute_id,$search_contentclass_attribute_id,
                           offset,$view_parameters.offset,
                           publish_date,$search_date,
                           limit,$page_limit))}
    {set $search_result=$search['SearchResult']}
    {set $search_count=$search['SearchCount']}
    {set $stop_word_array=$search['StopWordArray']}
    {set $search_data=$search}
{/if}
<script>
{literal}
// Read a page's GET URL variables and return them as an associative array.
function getUrlVars()
{
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');

    for(var i = 0; i < hashes.length; i++)
    {
        hash = hashes[i].split('=');
        vars.push(hash[0]);
        vars[hash[0]] = hash[1];
    }

    return vars;
}
$(function(){
	searchGetVars = getUrlVars();

	$('input[name=SearchText]').hide();
	$('input[name=FakeSearchText]').val(searchGetVars['FakeSearchText'].replace('+', ' '));

	if ({/literal}{$search_count}{literal} > 0) {
		$('#feedback_target').html('Search for "' + searchGetVars['FakeSearchText'].replace('+', ' ') + '" returned {/literal}{$search_count}{literal} results.');
	}

	$('#toggle_aks').toggle(
		function(){
			$('#advanced_keyword_search').slideUp();
			$('#toggle_aks').html('Advanced Keyword Search [+] (Search dialog collapses to display search results. Click [+] to expand the search dialog fields and conduct a search.)');
		},
		function(){
			$('#advanced_keyword_search').slideDown();
			$('#toggle_aks').html('Advanced Keyword Search [-]');
		}
	);

	$('#advancedsearch').submit(function(){
		var finalSearch = '';
		finalSearch += $('input[name=FakeSearchText]').val();
		$.each($('#keyword_target input:checkbox:checked'), function(){
			finalSearch += ' ' + $(this).val();
		});
		$('input[name=SearchText]').val(finalSearch);
	});

	$.getJSON('/betterkeywords/fetch', function(data){
		var out = '';
		$.each(data.categories, function(category, keywords){
			var group = '';
			group += '<h4>' + category + '</h4>';
			group += '<ul>';
			$.each(keywords, function(i, keyword){
				group += '<li>';
				group += '<input type="checkbox" value="' + keyword + '" name="' + keyword + '" id="' + keyword + '">';
				group += '<label for="' + keyword + '">' + keyword + '</label>';
				group += '</li>';
			});
			group += '</ul>';
			out += group;
		});
		$('#keyword_target').html(out);
		$.each($('#keyword_target input:checkbox'), function(){
			if (searchGetVars[$(this).val()]) {
				$(this).attr('checked', true);
			}
		});
	});

	$('#toggle_aks').click();
});
{/literal}
</script>
<style>
{literal}
#keyword_target ul {
	list-style-type: none;
}
#keyword_target ul li {
	margin-right: 2em;
	width: 205px;
	display: inline-block;
	position: relative;
}
#keyword_target ul li label {
	position: relative;
	bottom: 3px;
	left: 3px;
}
{/literal}
</style>


<div class="border-box">
<div class="border-tl"><div class="border-tr"><div class="border-tc"></div></div></div>
<div class="border-ml"><div class="border-mr"><div class="border-mc float-break">

<div class="content-advancedsearch">

<form id="advancedsearch" action={"/content/advancedsearch/"|ezurl} method="get">
<div class="attribute-header">
    <h1 class="long">{'Advanced search'|i18n( 'design/ezwebin/content/advancedsearch' )}</h1>
</div>

<div class="block">
<label>{'Search all the words'|i18n( 'design/ezwebin/content/advancedsearch' )}</label><div class="labelbreak"></div>
<input class="box" type="text" size="40" name="FakeSearchText" value="" />
<input class="box" type="text" size="40" name="SearchText" value="" />
</div>
<div class="block">
<label>{'Search the exact phrase'|i18n( 'design/ezwebin/content/advancedsearch' )}</label><div class="labelbreak"></div>
<input class="box" type="text" size="40" name="PhraseSearchText" value="{$phrase_search_text|wash}" />
</div>

<div class="block">
<div class="element">

<label>{'Published'|i18n( 'design/ezwebin/content/advancedsearch' )}</label><div class="labelbreak"></div>
<select name="SearchDate">
<option value="-1" {if eq( $search_date, '-1' )}selected="selected"{/if}>{'Any time'|i18n( 'design/ezwebin/content/advancedsearch' )}</option>
<option value="1" {if eq( $search_date, '1' )}selected="selected"{/if}>{'Last day'|i18n( 'design/ezwebin/content/advancedsearch' )}</option>
<option value="2" {if eq( $search_date, '2' )}selected="selected"{/if}>{'Last week'|i18n( 'design/ezwebin/content/advancedsearch' )}</option>
<option value="3" {if eq( $search_date, '3' )}selected="selected"{/if}>{'Last month'|i18n( 'design/ezwebin/content/advancedsearch' )}</option>
<option value="4" {if eq( $search_date, '4' )}selected="selected"{/if}>{'Last three months'|i18n( 'design/ezwebin/content/advancedsearch' )}</option>
<option value="5" {if eq( $search_date, '5' )}selected="selected"{/if}>{'Last year'|i18n( 'design/ezwebin/content/advancedsearch' )}</option>
</select>
</div>

{if $use_template_search}
<div class="element">
<label>{'Display per page'|i18n('design/ezwebin/content/advancedsearch')}</label><div class="labelbreak"></div>
<select name="SearchPageLimit">
<option value="1" {if eq( $search_page_limit,1 )}selected="selected"{/if}>{'5 items'|i18n( 'design/ezwebin/content/advancedsearch' )}</option>
<option value="2" {if or( array( 1, 2, 3, 4, 5 )|contains( $search_page_limit )|not, eq( $search_page_limit, 2 ) )}selected="selected"{/if}>{'10 items'|i18n( 'design/ezwebin/content/advancedsearch' )}</option>
<option value="3" {if eq( $search_page_limit, 3 )}selected="selected"{/if}>{'20 items'|i18n( 'design/ezwebin/content/advancedsearch' )}</option>
<option value="4" {if eq( $search_page_limit, 4 )}selected="selected"{/if}>{'30 items'|i18n( 'design/ezwebin/content/advancedsearch' )}</option>
<option value="5" {if eq( $search_page_limit, 5 )}selected="selected"{/if}>{'50 items'|i18n( 'design/ezwebin/content/advancedsearch' )}</option>
</select>
</div>
{/if}

{foreach $search_sub_tree as $sub_tree}
<input type="hidden" name="SubTreeArray[]" value="{$sub_tree}" />
{/foreach}


<div class="break"></div>
</div>

<p><a href="#" id="toggle_aks"></a></p>

<div id="advanced_keyword_search">
	<div id="keyword_target"></div>
</div>

<div class="buttonblock">
<input class="button" type="submit" name="SearchButton" value="{'Search'|i18n('design/ezwebin/content/advancedsearch')}" />
</div>

{if or( $search_text, eq( ezini( 'SearchSettings', 'AllowEmptySearch', 'site.ini'), 'enabled' ) )}
<br/>
{switch name=Sw match=$search_count}
  {case match=0}
<div class="warning">
<h2>{'No results were found when searching for "%1"'|i18n( 'design/ezwebin/content/advancedsearch', , array( $search_text|wash ) )}</h2>
</div>
  {/case}
  {case}
<div class="feedback">
{*
<h2>{'Search for "%1" returned %2 matches'|i18n( 'design/ezwebin/content/advancedsearch',,array( $search_text|wash, $search_count ) )}</h2>
*}
<h2 id="feedback_target"></h2>
</div>
  {/case}
{/switch}

{if $search_result|count()}
{foreach $search_result as $element}
   {node_view_gui view=line content_node=$element}
{/foreach}
{/if}

{/if}

{include name=navigator
         uri='design:navigator/google.tpl'
         page_uri='/content/advancedsearch'
         page_uri_suffix=concat('?SearchText=',$search_text|urlencode,'&PhraseSearchText=',$phrase_search_text|urlencode,'&SearchContentClassID=',$search_contentclass_id,'&SearchContentClassAttributeID=',$search_contentclass_attribute_id,'&SearchSectionID=',$search_section_id,$search_timestamp|gt(0)|choose('',concat('&SearchTimestamp=',$search_timestamp)),$search_sub_tree|gt(0)|choose( '', concat( '&', 'SubTreeArray[]'|urlencode, '=', $search_sub_tree|implode( concat( '&', 'SubTreeArray[]'|urlencode, '=' ) ) ) ),'&SearchDate=',$search_date,'&SearchPageLimit=',$search_page_limit)
         item_count=$search_count
         view_parameters=$view_parameters
         item_limit=$page_limit}

</form>

</div>

</div></div></div>
<div class="border-bl"><div class="border-br"><div class="border-bc"></div></div></div>
</div>
