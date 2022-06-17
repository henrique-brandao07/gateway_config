
#!/bin/sh

do_main() {
        now_lora=`ps w | grep -v grep | grep "lora_pkt_fwd"`
        if [ "$now_lora" = "" ] ; then
                
		/etc/init.d/gtk_spilora.service0 start
        fi
        return 0
}

do_main
