#!/bin/bash
ECHOIP=/opt/echoip/echoip
ARGS=()

if [[ -n "${MAXMIND_API}" ]]; then
	for db in 'GeoLite2-City' 'GeoLite2-Country' 'GeoLite2-ASN'; do
		curl -fsSL -m 30 "https://download.maxmind.com/app/geoip_download?edition_id=${db}&license_key=${MAXMIND_API}&suffix=tar.gz" | tar --wildcards --strip-components=1 -xzf - '*.mmdb'
		if [[ -e "${db}.mmdb" ]]; then
			case "${db}" in
				"GeoLite2-City")
					ARGS+=( "-c" "${db}.mmdb" )
					;;
				"GeoLite2-Country")
					ARGS+=( "-f" "${db}.mmdb" )
					;;
				"GeoLite2-ASN")
					ARGS+=( "-a" "${db}.mmdb" )
					;;
			esac
		fi
	done
fi


${ECHOIP} ${ARGS[@]} ${@}
