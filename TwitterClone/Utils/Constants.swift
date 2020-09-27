//
//  Constants.swift
//  TwitterClone
//
//  Created by 전해동 on 2020/09/20.
//

import Firebase

let DB_REF_ROOT: DatabaseReference = Database.database().reference()
let DB_REF_USERS: DatabaseReference = DB_REF_ROOT.child("users")

let STORAGE_REF_ROOT = Storage.storage().reference()
let STORAGE_REF_PROFILE_IMGS = STORAGE_REF_ROOT.child("profile_imgs")

let DB_REF_TWEETS: DatabaseReference = DB_REF_ROOT.child("tweets")
let DB_REF_USER_TWEETS: DatabaseReference = DB_REF_ROOT.child("user-tweets")

let DB_REF_USER_FOLLOWERS: DatabaseReference = DB_REF_ROOT.child("user-followers")
let DB_REF_USER_FOLLOWING: DatabaseReference = DB_REF_ROOT.child("user-following")
