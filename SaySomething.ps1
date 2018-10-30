Add-Type –AssemblyName System.Speech
$text = Read-Host "What should I say?"
$talk = New-Object –TypeName System.Speech.Synthesis.SpeechSynthesizer
$talk.Speak($text)