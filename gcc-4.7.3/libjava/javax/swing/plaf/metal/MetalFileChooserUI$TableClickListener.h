
// DO NOT EDIT THIS FILE - it is machine generated -*- c++ -*-

#ifndef __javax_swing_plaf_metal_MetalFileChooserUI$TableClickListener__
#define __javax_swing_plaf_metal_MetalFileChooserUI$TableClickListener__

#pragma interface

#include <java/awt/event/MouseAdapter.h>
extern "Java"
{
  namespace java
  {
    namespace awt
    {
      namespace event
      {
          class MouseEvent;
      }
    }
  }
  namespace javax
  {
    namespace swing
    {
        class JFileChooser;
        class JTable;
        class JTextField;
      namespace plaf
      {
        namespace metal
        {
            class MetalFileChooserUI;
            class MetalFileChooserUI$TableClickListener;
        }
      }
    }
  }
}

class javax::swing::plaf::metal::MetalFileChooserUI$TableClickListener : public ::java::awt::event::MouseAdapter
{

public:
  MetalFileChooserUI$TableClickListener(::javax::swing::plaf::metal::MetalFileChooserUI *, ::javax::swing::JTable *, ::javax::swing::JFileChooser *);
  virtual void mouseClicked(::java::awt::event::MouseEvent *);
public: // actually package-private
  virtual void editFile(jint);
  virtual void completeEditing();
public:
  virtual void closeDialog();
public: // actually package-private
  ::javax::swing::JTable * __attribute__((aligned(__alignof__( ::java::awt::event::MouseAdapter)))) table;
  ::javax::swing::JFileChooser * fc;
  ::java::lang::Object * lastSelected;
  ::java::io::File * editFile__;
  ::javax::swing::JTextField * editField;
  ::javax::swing::plaf::metal::MetalFileChooserUI * this$0;
public:
  static ::java::lang::Class class$;
};

#endif // __javax_swing_plaf_metal_MetalFileChooserUI$TableClickListener__
