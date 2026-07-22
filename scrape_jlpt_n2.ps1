$urls = @(
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page2/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page3/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page4/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page5/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page6/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page7/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page8/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page9/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page10/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page11/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page12/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page13/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page14/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page15/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page16/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page17/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page18/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page19/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page20/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page21/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page22/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page23/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page24/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page25/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page26/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page27/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page28/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page29/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n2/page30/"
)

$results = @()

foreach ($url in $urls) {
    Write-Host "Scraping $url"
    $response = Invoke-WebRequest -Uri $url -UseBasicParsing
    $html = $response.Content

    $rows = $html -split '<tr class="hover:bg-gray-100 cursor-pointer clickable-row transition-colors"'
    
    for ($i = 1; $i -lt $rows.Length; $i++) {
        $row = $rows[$i]
        
        $wordMatch = [regex]::Match($row, '<span class="text-lg font-medium text-gray-900">(.*?)</span>')
        $word = $wordMatch.Groups[1].Value.Trim()
        
        $pronMatch = [regex]::Match($row, '<div class="text-gray-600 mb-1">(.*?)</div>')
        $pronunciation = $pronMatch.Groups[1].Value.Trim()
        
        $meanMatch = [regex]::Match($row, '<td class="px-6 py-4 text-sm text-gray-700">(.*?)</td>')
        $meaningStr = $meanMatch.Groups[1].Value.Trim()
        
        $meanings = @($meaningStr -split ',' | ForEach-Object { $_.Trim() })
        
        if ($word -ne "") {
            $item = @{
                word = $word
                pronunciation = $pronunciation
                meaning = $meanings
            }
            $results += $item
        }
    }
}

$results | ConvertTo-Json -Depth 5 -Compress:$false | Out-File -FilePath "jlpt_n2_vocab.json" -Encoding utf8
Write-Host "Done! Saved to jlpt_n2_vocab.json"
