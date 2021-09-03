using System;
using System.Collections.Generic;
using System.Text;

namespace SnapMeta
{
    public interface IMediaService
    {
        void SaveImageFromByte(byte[] imageByte, string filename);
    }

}
