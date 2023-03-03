const fs = require('fs');
const path = require('path');


const getScriptMetadata = (txt) => {
    const get = (key) => {
        const match = new RegExp(`^##\\s*${key}:\\s*(.*)`, 'gm').exec(txt)
        return match?.[1] ?? ''
    }
    const base = Object.assign({}, ...['Author', 'Version', 'Description'].map(key => ({ [key.toLowerCase()]: get(key) })))
    const arguments = get('Arguments').split(',').filter(flag => flag.length)
    const flags = get('Flags').split(',').filter(flag => flag.length)
    return Object.assign({}, base, { arguments, flags })
}

const getMetadata = (relativeScriptPath) => {
    const lowerExtname = path.extname(relativeScriptPath).toLowerCase().slice(1)
    const shellMap = { ps1: 'powershell', sh: 'bash' }
    const shell = shellMap?.[lowerExtname] ?? ''
    const txt = fs.readFileSync(relativeScriptPath, 'utf8')
    const metadata = getScriptMetadata(txt)
    const name = path.parse(relativeScriptPath).name
    return {
        [name]: {
            ...metadata,
            shell,
            relativeScriptPath: `./${relativeScriptPath.split(path.sep).join(path.posix.sep)}`
        }
    }
}

const readDir = (dirName) => {
    const contents = fs.readdirSync(dirName, { withFileTypes: true })
    const subDirs = contents.filter(x => x.isDirectory()).map(dir => path.join(dirName, dir.name))
    const files = contents.filter(x => x.isFile()).map(file => path.join(dirName, file.name))
    return Object.assign(
        {},
        ...files.map(getMetadata),
        ...subDirs.map(readDir)
    )
}

const bash = readDir('./scripts/bash')
const powershell = readDir('./scripts/powershell')
const communityMetadata = { bash, powershell }
fs.writeFileSync('community-scripts-v2.json', JSON.stringify(communityMetadata, null, 2))