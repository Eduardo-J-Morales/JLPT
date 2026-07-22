$urls = @(
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page2/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page3/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page4/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page5/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page6/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page7/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page8/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page9/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page10/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page11/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page12/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page13/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page14/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page15/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page16/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page17/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page18/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page19/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page20/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page21/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page22/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page23/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page24/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page25/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page26/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page27/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page28/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page29/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page30/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page31/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page32/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page33/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page34/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page35/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page36/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page37/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page38/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page39/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page40/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page41/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page42/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page43/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page44/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page45/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page46/",
    "https://jlptbenkyo.com/vocabulary/jlpt-n1/page47/"
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

$results | ConvertTo-Json -Depth 5 -Compress:$false | Out-File -FilePath "jlpt_n1_vocab.json" -Encoding utf8
Write-Host "Done! Saved to jlpt_n1_vocab.json"
