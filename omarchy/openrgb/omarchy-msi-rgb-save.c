#include <hidapi/hidapi.h>
#include <stdio.h>

#define MSI_VID 0x1462
#define MSI_MAG_B650_TOMAHAWK_WIFI_PID 0x7D75
#define MSI_MYSTIC_LIGHT_REPORT_ID 0x52
#define MSI_MYSTIC_LIGHT_REPORT_SIZE 185
#define MSI_MYSTIC_LIGHT_SAVE_OFFSET 184

int main(void)
{
    struct hid_device_info *devices = NULL;
    struct hid_device_info *entry;
    hid_device *device = NULL;
    unsigned char report[MSI_MYSTIC_LIGHT_REPORT_SIZE] = {
        MSI_MYSTIC_LIGHT_REPORT_ID
    };
    int result = 1;

    if(hid_init() != 0)
    {
        fputs("Unable to initialize HIDAPI\n", stderr);
        return 1;
    }

    devices = hid_enumerate(MSI_VID, MSI_MAG_B650_TOMAHAWK_WIFI_PID);

    for(entry = devices; entry != NULL; entry = entry->next)
    {
        device = hid_open_path(entry->path);

        if(device == NULL)
        {
            continue;
        }

        report[0] = MSI_MYSTIC_LIGHT_REPORT_ID;

        if(hid_get_feature_report(device, report, sizeof(report))
            == (int)sizeof(report)
            && report[0] == MSI_MYSTIC_LIGHT_REPORT_ID)
        {
            break;
        }

        hid_close(device);
        device = NULL;
    }

    if(device == NULL)
    {
        fputs("MSI MAG B650 TOMAHAWK WIFI RGB controller was not found\n",
              stderr);
        goto cleanup;
    }

    /*
     * The OpenRGB MSI 185-byte driver uses the final byte as its manual-save
     * flag. Resend the controller's current state with that flag enabled so
     * the active Static color survives controller resets and power cycles.
     */
    report[MSI_MYSTIC_LIGHT_SAVE_OFFSET] = 1;

    if(hid_send_feature_report(device, report, sizeof(report))
        != (int)sizeof(report))
    {
        fputs("Failed to save the MSI Mystic Light state\n", stderr);
        goto cleanup;
    }

    result = 0;

cleanup:
    if(device != NULL)
    {
        hid_close(device);
    }

    hid_free_enumeration(devices);
    hid_exit();
    return result;
}
