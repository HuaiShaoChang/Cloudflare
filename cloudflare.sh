#!/usr/bin/env bash

shopt -s nocasematch

notSetEmailString="You haven't set your email of Cloudflare account!"
notSetAPIKeyString="You haven't set your global API Key of Cloudflare account!"
noKeyString="I don't need this."
noOptionString="I don't understand."

function setFile() {
    if [[ $1 = *=* ]]; then
        IFS='=' read -r -a pair <<< $1
        key=${pair[0]}
        value=${pair[1]}
        case $key in
            Email)
                echo $value > AuthEmail
                ;;
            APIKey)
                echo $value > AuthKey
                ;;
            *) echo $noKeyString;;
        esac
    else
        case $1 in
            Email)
                if [ -e AuthEmail ]; then
                    IFS= read content < AuthEmail; echo $content
                else
                    echo $notSetEmailString >&2
                    exit 1
                fi
                ;;
            APIKey)
                if [ -e AuthAPI ]; then
                    IFS= read content < AuthAPI; echo $content
                else
                    echo $notSetAPIKeyString >&2
                    exit 1
                fi
                ;;
            *) echo $noOptionString;;
        esac
    fi
}

function dns() {
    EndPoint="https://api.cloudflare.com/client/v4"
    ContentType="application/json"
    if [ ! -e AuthEmail ]; then
        echo "$notSetEmailString Try" >&2
        echo "  $0 set Email=<Your email of Cloudflare account>" >&2
        exit 1
    fi
    if [ ! -e AuthAPIKey ]; then
        echo "$notSetAPIKeyString Try" >&2
        echo "  $0 set APIKey=<Your global API Key of Cloudflare account>" >&2
        exit 1
    fi
    AuthEmail=`cat AuthEmail`
    AuthKey=`cat APIKey`
}

case $1 in
    set)
        if [ $# -gt 1 ]; then setFile $2
        else echo "What do you wanna set?"
        fi
        ;;
    dns) dns;;
    help)
        echo "For DNS manipulating use: $0 dns ..."
        ;;
    *) echo "What do you wanna do?"
        echo "  Try \"$0 help [command]\""
        ;;
esac
