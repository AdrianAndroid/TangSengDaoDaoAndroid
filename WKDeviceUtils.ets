import { deviceInfo } from '@kit.BasicServicesKit'
import { util } from '@kit.ArkTS'
import { fileIo } from '@kit.CoreFileKit'
import { cryptoFramework } from '@kit.CryptoArchitectureKit'
import { connection } from '@kit.NetworkKit'

export class WKDeviceUtils {
  private readonly SP_DEVICES_ID: string = "SHARE_PREFERCE_DEVICE_ID"
  private readonly CACHE_IMAGE_DIR: string = "aray/cache/devices"
  private readonly DEVICES_FILE_NAME: string = ".DEVICES"

  private static instance: WKDeviceUtils = new WKDeviceUtils()

  private constructor() {}

  static getInstance(): WKDeviceUtils {
    return WKDeviceUtils.instance
  }

  async initDeviceID(): Promise<void> {
    try {
      // 获取保存的设备唯一标识符
      const readDeviceID = await this.readDeviceID()
      // 获取缓存的设备唯一标识
      let cachedID = WKSharedPreferencesUtil.getInstance().getSP(this.SP_DEVICES_ID, readDeviceID)
      
      if (cachedID) {
        // 如果缓存的和文件中的不同，以缓存的为准
        if (!readDeviceID && cachedID !== readDeviceID) {
          if (!readDeviceID && cachedID) {
            await this.saveDeviceID(cachedID)
          }
        }
      }

      // 如果没有设备ID，生成新的
      if (!readDeviceID) {
        const newDeviceID = await this.getDeviceId()
        await this.saveDeviceID(newDeviceID)
        WKSharedPreferencesUtil.getInstance().putSP(this.SP_DEVICES_ID, newDeviceID)
      } else {
        WKSharedPreferencesUtil.getInstance().putSP(this.SP_DEVICES_ID, readDeviceID)
      }
    } catch (error) {
      console.error('initDeviceID error:', error)
    }
  }

  async getDeviceId(): Promise<string> {
    // 读取保存的设备ID
    let deviceId = await this.readDeviceID()
    if (deviceId) {
      return deviceId
    }

    let deviceInfo = ''
    
    try {
      // 获取设备信息
      deviceInfo += this.getDeviceInfo()
    } catch (error) {
      console.error('getDeviceInfo error:', error)
    }

    try {
      // 获取MAC地址
      const macAddress = await this.getLocalMac()
      deviceInfo += macAddress.replace(/:/g, '')
    } catch (error) {
      console.error('getLocalMac error:', error)
    }

    // 如果没有获取到设备信息，生成UUID
    if (!deviceInfo) {
      deviceInfo = util.generateRandomUUID().replace(/-/g, '')
    }

    // MD5加密
    const md5Hash = await this.getMD5(deviceInfo)
    if (md5Hash) {
      await this.saveDeviceID(md5Hash)
    }
    
    return md5Hash || deviceInfo
  }

  private getDeviceInfo(): string {
    try {
      return deviceInfo.deviceId || ''
    } catch (error) {
      return ''
    }
  }

  async saveDeviceID(deviceID: string): Promise<void> {
    try {
      const filePath = this.getDevicesFilePath()
      await fileIo.writeText(filePath, deviceID)
    } catch (error) {
      console.error('saveDeviceID error:', error)
    }
  }

  private async getLocalMac(): Promise<string> {
    try {
      const netHandle = await connection.getDefaultNet()
      const connectionProperties = await connection.getConnectionProperties(netHandle)
      // 鸿蒙系统中MAC地址获取受限，返回空字符串
      return ''
    } catch (error) {
      return ''
    }
  }

  private async readDeviceID(): Promise<string> {
    try {
      const filePath = this.getDevicesFilePath()
      if (await fileIo.access(filePath)) {
        return await fileIo.readText(filePath)
      }
    } catch (error) {
      console.error('readDeviceID error:', error)
    }
    return ''
  }

  private getDevicesFilePath(): string {
    const context = getContext()
    return `${context.filesDir}/${this.CACHE_IMAGE_DIR}/${this.DEVICES_FILE_NAME}`
  }

  private async getMD5(input: string): Promise<string> {
    try {
      const md = cryptoFramework.createMd('MD5')
      await md.update({ data: new Uint8Array(Buffer.from(input, 'utf-8')) })
      const result = await md.digest()
      return Buffer.from(result.data).toString('hex')
    } catch (error) {
      console.error('getMD5 error:', error)
      return input
    }
  }

  getSystemModel(): string {
    return deviceInfo.productModel || 'Unknown'
  }

  getDeviceName(): string {
    const manufacturer = deviceInfo.manufacture || 'Unknown'
    const model = deviceInfo.productModel || 'Unknown'
    
    if (model.startsWith(manufacturer)) {
      return this.capitalize(model)
    } else {
      return `${this.capitalize(manufacturer)} ${model}`
    }
  }

  getSystemVersion(): string {
    return deviceInfo.osFullName || 'Unknown'
  }

  private capitalize(str: string): string {
    if (!str || str.length === 0) {
      return ''
    }
    return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase()
  }
}

// 需要实现的工具类接口
interface WKSharedPreferencesUtil {
  getSP(key: string, defaultValue?: string): string
  putSP(key: string, value: string): void
}