<?php
return [
    'BE' => [
        'createGroup' => 'www-data',
        'fileCreateMask' => '0664',
        'folderCreateMask' => '0775',
        'forceCharset' => 'utf-8',
        'loginSecurityLevel' => 'normal',
        'maxFileSize' => '65536',
    ],
    'EXT' => [
        'allowLocalInstall' => '0',
        'extConf' => [],
    ],
    'FE' => [
        'loginSecurityLevel' => 'normal',
    ],
    'SYS' => [
        'ddmmyy' => 'd.m.y',
        'devIPmask' => '*',
        'phpTimeZone' => 'Europe/Berlin',
        'setDBinit' => 'SET NAMES utf8;',
        'sitename' => 'dkdeploy dev',
        'systemLog' => 'error_log,,0',
        't3lib_cs_convMethod' => 'mbstring',
        't3lib_cs_utils' => 'mbstring',
        'encryptionKey' => 'iamarandompw'
    ],
];
