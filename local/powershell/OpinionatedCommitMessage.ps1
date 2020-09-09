#!/usr/bin/env pwsh
# This file was generated by src/scripts/toPowershell.ts. Do NOT edit or append!
# Version: 2.1.2
# Copyright (c) 2020 Marko Ristin <https://github.com/mristin/opinionated-commit-message>
# MIT License

param(
    [Parameter(HelpMessage = "Message to be verified", Mandatory = $true)]
    [string]
    $message,

    [Parameter(HelpMessage = "Additional verbs in imperative mood separated by comma, semicolon or newline")]
    [string]
    $additionalVerbs = $null,

    [Parameter(HelpMessage = "Path to additional verbs in imperative mood")]
    [string]
    $pathToAdditionalVerbs = $null,

    [Parameter(HelpMessage = "If set, one-liner commit messages are allowed")]
    [switch]
    $allowOneLiners = $false,

    [Parameter(HelpMessage = "If set, the script does not throw an exception on failed checks")]
    [switch]
    $dontThrow = $false
)

<#
.SYNOPSIS
This script checks commit messages according to an opinionated style.

.DESCRIPTION
Opinionated-commit-message is a GitHub Action which checks commit messages according to an opinionated style.
This script is a rewrite in Powershell meant for local usage.

The style was inspired by https://chris.beams.io/posts/git-commit/:
* Separate subject from body with a blank line
* Limit the subject line to 50 characters
* Capitalize the subject line
* Do not end the subject line with a period
* Use the imperative mood in the subject line
* Wrap the body at 72 characters
* Use the body to explain what and why (instead of how)

Here is an example commit message:
```
Set up Open ID HttpClient with default proxy

Previously, the Open ID HttpClient was simply instantiated without
default proxy credentials. However, if there are company proxies,
HttpClient must use the default proxy with OpenID Connect.
```
#>

# This list is automatically filled out by src/scripts/toPowershell.ts.
# Do NOT edit or append!
$frequentVerbs = @(
'abandon',
'accept',
'accompany',
'account',
'accuse',
'ache',
'achieve',
'acknowledge',
'acquire',
'act',
'active',
'add',
'address',
'adhere',
'adjust',
'admit',
'adopt',
'advise',
'advocate',
'affect',
'affirm',
'afford',
'agree',
'aim',
'align',
'allow',
'alter',
'analyse',
'analyze',
'announce',
'annoy',
'annul',
'answer',
'appeal',
'appear',
'applicate',
'apply',
'appoint',
'appreciate',
'approach',
'approve',
'argue',
'arise',
'arrange',
'arrest',
'arrive',
'ask',
'assert',
'assess',
'assign',
'assist',
'associate',
'assume',
'assure',
'attach',
'attack',
'attempt',
'attend',
'attract',
'avoid',
'awake',
'back',
'backup',
'bake',
'base',
'battle',
'be',
'bear',
'beat',
'become',
'begin',
'behave',
'believe',
'belong',
'bend',
'benefit',
'better',
'beware',
'bind',
'blacklist',
'blame',
'blend',
'blow',
'born',
'bother',
'break',
'bring',
'build',
'bump',
'burn',
'busy',
'buy',
'cache',
'calculate',
'call',
'capture',
'care',
'carry',
'carryout',
'cast',
'catch',
'categorize',
'cause',
'challenge',
'change',
'chant',
'charge',
'chase',
'chat',
'check',
'choose',
'circle',
'claim',
'clarify',
'clean',
'cleanse',
'clear',
'climb',
'close',
'clothe',
'collapse',
'collect',
'combine',
'come',
'command',
'comment',
'commit',
'compare',
'compensate',
'compile',
'complain',
'complete',
'compose',
'compress',
'conceal',
'concentrate',
'conclude',
'concur',
'conduct',
'configure',
'confirm',
'confront',
'connect',
'connote',
'consider',
'consist',
'consolidate',
'constitute',
'construct',
'consume',
'contact',
'contain',
'contest',
'continue',
'contribute',
'control',
'convert',
'convey',
'cook',
'cope',
'correct',
'cost',
'counsel',
'count',
'cover',
'create',
'cross',
'cry',
'cut',
'damage',
'dance',
'deal',
'debate',
'decide',
'declare',
'deconstruct',
'defeat',
'defend',
'define',
'delay',
'delete',
'deliver',
'demand',
'demolish',
'demonstrate',
'deny',
'depart',
'depend',
'depict',
'derive',
'describe',
'design',
'desire',
'destroy',
'detail',
'detect',
'determine',
'develop',
'devote',
'die',
'direct',
'disable',
'disappear',
'discourage',
'discover',
'discuss',
'dislike',
'dismiss',
'displace',
'display',
'distinguish',
'divide',
'do',
'document',
'dominate',
'downgrade',
'draw',
'dread',
'dress',
'drink',
'drive',
'drop',
'earn',
'eat',
'echo',
'edit',
'educate',
'elect',
'elevate',
'emerge',
'employ',
'enable',
'encourage',
'end',
'endorse',
'endure',
'enforce',
'engage',
'enjoy',
'enquire',
'enroll',
'ensure',
'enter',
'enumerate',
'equal',
'equate',
'erase',
'escape',
'establish',
'estimate',
'evaluate',
'examine',
'except',
'exclude',
'excuse',
'execute',
'exercise',
'exert',
'exist',
'expand',
'expect',
'experience',
'explain',
'explore',
'express',
'extend',
'extract',
'face',
'fail',
'fall',
'fault',
'fear',
'feature',
'feed',
'feel',
'fight',
'fill',
'find',
'finish',
'fit',
'fix',
'flatten',
'flee',
'float',
'flunk',
'fly',
'focus',
'follow',
'force',
'foresee',
'forget',
'form',
'format',
'forward',
'found',
'free',
'gain',
'gather',
'generate',
'get',
'gitignore',
'give',
'giveup',
'glance',
'go',
'going',
'govern',
'grant',
'grin',
'grow',
'guess',
'guide',
'hand',
'handle',
'hang',
'happen',
'harm',
'hate',
'have',
'head',
'hear',
'help',
'hide',
'hint',
'hire',
'hit',
'hold',
'hope',
'house',
'hurt',
'identify',
'ignore',
'illuminate',
'illustrate',
'imagine',
'implement',
'imply',
'importune',
'impose',
'improve',
'in-line',
'include',
'incorporate',
'increase',
'incur',
'indicate',
'influence',
'inform',
'initialize',
'initiate',
'injure',
'inline',
'insist',
'install',
'integrate',
'intend',
'intercept',
'internalize',
'interpret',
'introduce',
'invalidate',
'invest',
'investigate',
'invite',
'involve',
'issue',
'join',
'journey',
'joy',
'judge',
'jump',
'justify',
'keep',
'key',
'kick',
'kill',
'kiss',
'knock',
'know',
'label',
'lack',
'land',
'last',
'laugh',
'launch',
'lay',
'lead',
'lean',
'leap',
'learn',
'leave',
'let',
'lie',
'lift',
'light',
'like',
'limit',
'link',
'list',
'listen',
'live',
'locate',
'lock',
'look',
'lose',
'love',
'maintain',
'make',
'manage',
'map',
'mark',
'marry',
'match',
'materialize',
'matter',
'mean',
'measure',
'meet',
'menace',
'mention',
'merge',
'mind',
'misinform',
'miss',
'mix',
'move',
'mutate',
'name',
'near',
'need',
'nod',
'note',
'notice',
'observe',
'obtain',
'occupy',
'occur',
'offer',
'officiate',
'omit',
'open',
'operate',
'order',
'organise',
'organize',
'override',
'owe',
'own',
'pack',
'package',
'paint',
'partake',
'pass',
'pay',
'perform',
'permit',
'persuade',
'pick',
'pin',
'place',
'plan',
'play',
'plow',
'point',
'ponder',
'possess',
'pour',
'predict',
'prefer',
'prepare',
'present',
'preserve',
'press',
'presume',
'prevent',
'print',
'privatize',
'proceed',
'process',
'procure',
'produce',
'promise',
'promote',
'propose',
'prosecute',
'protect',
'protest',
'prove',
'provide',
'publish',
'pull',
'purchase',
'pursue',
'push',
'put',
'puton',
'qualify',
'question',
'quote',
'race',
'raise',
'randomize',
're-define',
're-do',
're-instate',
'reach',
'read',
'realise',
'realize',
'reason',
'recall',
'receive',
'reckon',
'recognise',
'recognize',
'recommend',
'record',
'recover',
'recur',
'rede',
'redefine',
'redo',
'reduce',
'refactor',
'refer',
'reference',
'reflect',
'reformat',
'refresh',
'refuse',
'regard',
'register',
'reinstate',
'reject',
'relate',
'relax',
'release',
'rely',
'remain',
'remember',
'remind',
'remove',
'rename',
'reorder',
'reorganise',
'reorganize',
'repair',
'repeat',
'repel',
'rephrase',
'replace',
'reply',
'report',
'represent',
'request',
'require',
'research',
'reside',
'resolve',
'respond',
'rest',
'restore',
'restrict',
'restructure',
'result',
'retain',
'retire',
'retreat',
'return',
'reveal',
'revert',
'review',
'reword',
'rewrap',
'rewrite',
'ride',
'ring',
'rise',
'roll',
'rule',
'run',
'sale',
'salute',
'sample',
'save',
'say',
'score',
'search',
'secure',
'see',
'seek',
'seem',
'select',
'self-initialize',
'sell',
'send',
'separate',
'serve',
'set',
'settle',
'shake',
'shape',
'share',
'shift',
'shoot',
'shout',
'show',
'shut',
'sign',
'signify',
'simplify',
'sing',
'sit',
'sleep',
'slide',
'slip',
'smile',
'solve',
'sort',
'sound',
'speak',
'specify',
'spend',
'split',
'spread',
'stand',
'standardize',
'stare',
'start',
'state',
'stay',
'steal',
'steer',
'step',
'stick',
'stop',
'stress',
'stretch',
'strike',
'struggle',
'study',
'submit',
'succeed',
'suffer',
'suggest',
'suit',
'supply',
'support',
'suppose',
'surround',
'survive',
'suspect',
'sway',
'switch',
'sync',
'synchronise',
'synchronize',
'take',
'talk',
'talkover',
'target',
'teach',
'tell',
'tempt',
'tend',
'terminate',
'test',
'testify',
'thank',
'think',
'threaten',
'throw',
'tie',
'touch',
'track',
'trade',
'train',
'transfer',
'translate',
'travel',
'tread',
'treat',
'trim',
'trust',
'try',
'turn',
'twist',
'uncover',
'understand',
'undertake',
'undo',
'unfold',
'unify',
'unite',
'unload',
'unpack',
'unskip',
'unwrap',
'update',
'upgrade',
'urge',
'use',
'utter',
'value',
'vanish',
'vary',
'view',
'visit',
'vocalize',
'voice',
'vote',
'wait',
'wake',
'walk',
'want',
'warn',
'warrant',
'wash',
'watch',
'wear',
'weep',
'weigh',
'welcome',
'whitelist',
'win',
'wish',
'withdraw',
'wonder',
'work',
'workout',
'worry',
'wrap',
'write'
)

# This list is automatically filled out by src/scripts/toPowershell.ts.
# Do NOT edit or append!


function ParseAdditionalVerbs($text)
{
    [string[]]$verbs = @()

    $lines = $text -Split "`n"

    foreach ($line in $lines)
    {
        $parts = [Regex]::split($line, '[,;]')
        foreach ($part in $parts)
        {
            $trimmed = $part.Trim()
            if ($trimmed -ne "")
            {
                $verbs += $trimmed.ToLower()
            }
        }
    }

    return $verbs
}

$capitalizedWordRe = [Regex]::new('^([A-Z][a-z]*)[^a-zA-Z]')
$suffixHashCodeRe = [Regex]::new('\s?\(\s*#[a-zA-Z_0-9]+\s*\)$')

function CheckSubject([string]$subject, [hashtable]$verbs)
{
    # Precondition
    foreach ($verb in $verbs.Keys)
    {
        if ($verb -eq "")
        {
            throw "Unexpected empty verb"
        }

        if ($verb -ne $verb.ToLower())
        {
            throw "Expected all verbs to be lowercase, but got: $verb"
        }
    }

    [string[]]$errors = @()

    $subjectWoCode = $subject -Replace $suffixHashCodeRe
    if ($subjectWoCode.Length -gt 50)
    {
        $errors += "The subject exceeds the limit of 50 characters " +    `
              "(got: $( $subjectWoCode.Length )): $( $subjectWoCode|ConvertTo-Json )"
    }

    $matches = $capitalizedWordRe.Matches($subjectWoCode)
    if ($matches.Count -ne 1)
    {
        $errors += 'The subject must start with a capitalized verb (e.g., "Change").'
    }
    else
    {
        $match = $matches[0]
        $word = $match.Groups[1].Value
        $wordLower = $word.ToLower()

        if (!$verbs.Contains($wordLower) -or ($false -eq $verbs[$wordLower]))
        {
            $errors += "The subject must start with a verb in imperative mood (according to a whitelist), " +   `
                  "but got: $($word|ConvertTo-Json); if this is a false positive, consider adding the verb " + `
                  "to -additionalVerbs or to the file referenced by -pathToAdditionalVerbs."
        }
    }

    if ( $subjectWoCode.EndsWith("."))
    {
        $errors += "The subject must not end with a dot ('.')."
    }

    return $errors
}

$urlLineRe = [Regex]::new('^[^ ]+://[^ ]+$')
$linkDefinitionRe = [Regex]::new('^\[[^\]]+]\s*:\s*[^ ]+://[^ ]+$')

function CheckBody([string]$subject, [string[]] $bodyLines)
{
    $errors = @()

    if($bodyLines.Count -eq 0)
    {
        $errors += "At least one line is expected in the body, but got empty body."
        return $errors
    }

    if (($bodyLines.Length -eq 1) -and ($bodyLines[0].Trim -eq ""))
    {
        $errors += "Unexpected empty body"
        return $errors
    }

    for($i = 0; $i -lt $bodyLines.Count; $i++)
    {
        $line = $bodyLines[$i]

        if ($urlLineRe.IsMatch($line) -or $linkDefinitionRe.IsMatch($line))
        {
            continue;
        }

        if($line.Length -gt 72)
        {
            $errors += "The line $($i + 3) of the message (line $($i + 1) of the body) " + `
                "exceeds the limit of 72 characters. The line contains $($line.Length) characters: " + `
                "$($line|ConvertTo-Json)."
        }
    }

    $bodyFirstWordMatches = $capitalizedWordRe.Matches($bodyLines[0])
    if($bodyFirstWordMatches.Count -eq 1)
    {
        $bodyFirstWord = $bodyFirstWordMatches[0].Groups[1].Value

        $subjectFirstWordMatches = $capitalizedWordRe.Matches($subject)
        if($subjectFirstWordMatches.Count -eq 1)
        {
            $subjectFirstWord = $subjectFirstWordMatches[0].Groups[1].Value

            if($subjectFirstWord.ToLower() -eq $bodyFirstWord.ToLower())
            {
                $errors += "The first word of the subject ($($subjectFirstWord|ConvertTo-Json)) must not match " + `
                    "the first word of the body."
            }
        }
    }

    return $errors
}

function Check([string]$text, [hashtable]$verbs)
{
    [string[]]$errors = @()

    if($text.StartsWith("Merge branch"))
    {
        return $errors
    }

    $lines = $text -Split "`n"
    $trimmedLines = @()
    foreach ($line in $lines)
    {
        $trimmedLines += $line -Replace '\r$'
    }

    if ($trimmedLines.Count -eq 0)
    {
        errors += "The message is empty."
        return $errors
    }
    elseif (($trimmedLines.Length -eq 1) -and $allowOneLiners)
    {
        $subject = $trimmedLines[0]
        $errors = $errors + ( CheckSubject -subject $subject -verbs $verbs )
    }
    else
    {
        if (($trimmedLines.Length -eq 0) -or ($trimmedLines.Length -eq 1))
        {
            $errors += "Expected at least three lines (subject, empty, body), but got: $( $lines.Count )"
            return $errors
        }
        elseif ($trimmedLines.Length -eq 2)
        {
            $errors += (
                "Expected at least three lines (subject, empty, body) in a multi-line message, " +
                "but got: $( $lines.Count )"
            )
            return $errors
        }
        else
        {
            if ($trimmedLines[1] -ne "")
            {
                $errors += "Expected an empty line between the subject and the body, " +   `
                               "but got a line: $( $trimmedLines[1]|ConvertTo-Json )"
                return $errors
            }

            $subject = $trimmedLines[0]
            $errors = $errors + ( CheckSubject -subject $subject -verbs $verbs )

            $bodyLines = $trimmedLines |Select-Object -Skip 2
            $errors = $errors + ( CheckBody -subject $subject -bodyLines $bodyLines)
        }
    }

    return $errors
}

function Main
{
    $verbs = @{ }

    if ($null -ne $additionalVerbs)
    {
        $verbList = ParseAdditionalVerbs($additionalVerbs)
        foreach ($verb in $verbList)
        {
            $verbs[$verb] = $true
        }
    }

    if ($null -ne $pathToAdditionalVerbs -and ("" -ne $pathToAdditionalVerbs))
    {
        if (!(Test-Path $pathToAdditionalVerbs))
        {
            throw "The file referenced by pathTAdditionalVerbs does not exist: $( $pathToAdditionalVerbs|ConvertTo-Json )"
        }

        $verbList = ParseAdditionalVerbs(Get-Content -Path $pathToAdditionalVerbs)
        foreach ($verb in $verbList)
        {
            $verbs[$verb] = $true
        }
    }

    foreach ($verb in $frequentVerbs)
    {
        $verbs[$verb] = $true
    }

    $errors = Check -text $message -verbs $verbs

    if ($errors.Count -eq 0)
    {
        Write-Host "The message is OK."
    }
    else
    {
        foreach ($error in $errors)
        {
            Write-Host "* $error"
        }

        if (!$dontThrow)
        {
            throw "One or more checks failed."
        }
    }
}

Main

# This file was generated by src/scripts/toPowershell.ts. Do NOT edit or append!